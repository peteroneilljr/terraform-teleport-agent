# ---------------------------------------------------------------------------- #
# Create a password for Windows machine
# ---------------------------------------------------------------------------- #
resource "random_password" "windows" {
  length = 40
}
# ---------------------------------------------------------------------------- #
# Create windows AWS Instances
# ---------------------------------------------------------------------------- #
module "windows_instances" {
  source = "terraform-aws-modules/ec2-instance/aws"

  create = local.teleport.rdp

  for_each = toset([
    "dev",
    "prod",
  ])

  name = "teleport-${each.key}"

  instance_type          = "t3.small"
  key_name               = aws_key_pair.peter.id
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.private_subnets[3]

  user_data_replace_on_change = true
  user_data = templatefile("${path.module}/config/windows.tftpl", {
    User     = "yoko"
    Password = random_password.windows.result
    Version  = var.teleport_version
    Proxy    = "https://${var.teleport_proxy_address}"
  })

  get_password_data = true

  ami                = local.ami.windows
  ignore_ami_changes = true

  metadata_options = {
    http_endpoint : "enabled"
    http_tokens : "required"
  }
}
# ---------------------------------------------------------------------------- #
# Create Teleport Agent to proxy windows machines
# ---------------------------------------------------------------------------- #
module "windows_teleport" {
  source = "../modules/terraform-teleport-agent-v2"

  create = local.teleport.rdp

  vpc_id                = module.vpc.vpc_id
  vpc_security_group_id = module.vpc.default_security_group_id
  vpc_subnet_id         = module.vpc.private_subnets[0]

  agent_nodename = "win-agent"

  teleport_proxy_address = var.teleport_proxy_address
  teleport_version       = var.teleport_version
  teleport_ssh_labels = {
    "type" = "agent"
  }
  teleport_windows = true

  teleport_windows_hosts = {
    "development" = {
      "env"  = "dev"
      "addr" = local.teleport.rdp ? module.windows_instances["dev"].private_ip : "1.1.1.1"
    }
    "production" = {
      "env"  = "prod"
      "addr" = local.teleport.rdp ? module.windows_instances["prod"].private_ip : "1.1.1.1"
    }
  }

  aws_key_pair = aws_key_pair.peter.id

}