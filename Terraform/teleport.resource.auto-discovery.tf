# ---------------------------------------------------------------------------- #
# Assign EC2 SSM Profile for management
# ---------------------------------------------------------------------------- #
resource "aws_iam_role_policy_attachment" "managed_instance" {
  role       = aws_iam_role.managed_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role" "managed_instance" {
  name = "${local.prefix}ManagedInstanceRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_instance_profile" "managed_instance" {
  name = "${local.prefix}ManagedInstanceProfile"
  role = aws_iam_role.managed_instance.name
}
# ---------------------------------------------------------------------------- #
# Create Instances to be discovered
# ---------------------------------------------------------------------------- #
module "auto_discovery_nodes" {
  source = "terraform-aws-modules/ec2-instance/aws"

  create = local.teleport.auto_discovery

  for_each = toset([
    "dev",
  ])

  name = "teleport-${each.key}"

  user_data = <<USER
  hostname "teleport-${each.key}"
  USER

  iam_instance_profile = aws_iam_instance_profile.managed_instance.name

  instance_type          = "t3.nano"
  key_name               = aws_key_pair.peter.id
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.private_subnets[3]

  ami                = local.ami.amzn_linux
  ignore_ami_changes = true

  metadata_options = {
    http_endpoint : "enabled"
    http_tokens : "required"
    instance_metadata_tags : "disabled"
  }

  tags = {
    "env"       = "dev"
    "discovery" = "ec2"
    "os"        = "amzn-linux"
  }
}
# ---------------------------------------------------------------------------- #
# Create Teleport Agent with Discovery Service Running
# ---------------------------------------------------------------------------- #
module "auto_discovery_agent" {
  source = "../modules/terraform-teleport-agent-v2"

  create             = local.teleport.auto_discovery
  teleport_discovery = local.teleport.auto_discovery

  vpc_id                = module.vpc.vpc_id
  vpc_security_group_id = module.vpc.default_security_group_id

  vpc_subnet_id = module.vpc.public_subnets[0]
  vpc_public_ip = true

  agent_nodename = "discovery-agent"

  teleport_proxy_address         = var.teleport_proxy_address
  teleport_version               = var.teleport_version
  teleport_discovery_token       = try(teleport_provision_token.discovery_token[0].metadata.name, "")
  teleport_discovery_ssm_install = try(aws_ssm_document.auto_discovery[0].name, "")
  teleport_ssh_labels = {
    "type" = "agent"
  }
  aws_key_pair         = aws_key_pair.peter.id
  aws_instance_profile = try(aws_iam_instance_profile.auto_discovery[0].name, null)

  teleport_discovery_tags = {
    "discovery" = "ec2"
  }
}
# ---------------------------------------------------------------------------- #
# Discovery SSM Documents
# ---------------------------------------------------------------------------- #  
resource "teleport_provision_token" "discovery_token" {
  count = local.teleport.auto_discovery ? 1 : 0

  version = "v2"
  spec = {

    join_method = "iam"

    roles = [
      "Node",
    ]

    allow = [
      { aws_account = var.aws_account_id },
    ]

  }
  metadata = {
    name    = "discovery-token"
    expires = null # Long lived static token for discovery

    labels = {
      "teleport.dev/origin" = "dynamic"
    }
  }
}

# ---------------------------------------------------------------------------- #
# aws ssm documents
# ---------------------------------------------------------------------------- #

resource "aws_iam_policy" "auto_discovery" {
  count = local.teleport.auto_discovery ? 1 : 0

  name = "${local.prefix}Ec2AutoDiscoveryPolicy"
  path = "/"

  policy = data.aws_iam_policy_document.auto_discovery[count.index].json
}
data "aws_iam_policy_document" "auto_discovery" {
  count = local.teleport.auto_discovery ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ssm:CreateDocument",
      "ssm:DescribeInstanceInformation",
      "ssm:GetCommandInvocation",
      "ssm:ListCommandInvocations",
      "ssm:SendCommand"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "auto_discovery" {
  count = local.teleport.auto_discovery ? 1 : 0

  role       = aws_iam_role.auto_discovery[count.index].name
  policy_arn = aws_iam_policy.auto_discovery[count.index].arn
}
resource "aws_iam_role" "auto_discovery" {
  count = local.teleport.auto_discovery ? 1 : 0

  name = "${local.prefix}Ec2AutoDiscoveryRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_instance_profile" "auto_discovery" {
  count = local.teleport.auto_discovery ? 1 : 0

  name = "${local.prefix}Ec2AutoDiscoveryProfile"
  role = aws_iam_role.auto_discovery[count.index].name
}

resource "aws_ssm_document" "auto_discovery" {
  count = local.teleport.auto_discovery ? 1 : 0

  name            = "${local.prefix}TeleportEc2AutoDiscovery"
  document_format = "YAML"
  document_type   = "Command"

  content = <<DOC
schemaVersion: '2.2'
description: aws:runShellScript
parameters:
  token:
    type: String
    description: "(Required) The Teleport invite token to use when joining the cluster."
  scriptName:
    type: String
    description: "(Required) The Teleport installer script to use when joining the cluster."
mainSteps:
- action: aws:downloadContent
  name: downloadContent
  inputs:
    sourceType: "HTTP"
    destinationPath: "/tmp/installTeleport.sh"
    sourceInfo:
      url: "https://${var.teleport_proxy_address}:443/webapi/scripts/installer/{{ scriptName }}"
- action: aws:runShellScript
  name: runShellScript
  inputs:
    timeoutSeconds: '300'
    runCommand:
      - /bin/sh /tmp/installTeleport.sh "{{ token }}"
DOC
}