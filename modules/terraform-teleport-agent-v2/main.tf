resource "random_string" "teleport_agent" {
  count = var.create ? 1:0

  length  = 32
  special = false
}
resource "teleport_provision_token" "teleport_agent" {
  count = var.create ? 1:0

  version = "v2"
  spec = {
    roles = compact([
      "Node",
      "${var.teleport_app ? "App" : null}",
      "${var.teleport_db ? "Db" : null}",
      "${var.teleport_windows ? "WindowsDesktop" : null}",
      "${var.teleport_discovery ? "Discovery" : null}",
    ])
  }
  metadata = {
    name = random_string.teleport_agent[count.index].result
    expires = timeadd(timestamp(), "4h")

    labels = {
      "iac"                 = "tofu"
      "teleport.dev/origin" = "dynamic" 
    }
  }
  lifecycle {
    ignore_changes = [
      metadata.expires,
    ]
  }
}

resource "local_file" "teleport_config" {
  count = var.create ? 1:0

  filename = "${path.module}/configs/${var.agent_nodename}-teleport.conf"

  content  = <<-EOF
  ${local.commands.shell}
  ${local.commands.usershell}
  ${local.commands.token}
  ${local.commands.hostname}
  ${local.install.teleport}
  ${var.teleport_db ? local.install.rds : ""}
  ${local.resources.start}
  ${local.resources.ssh}
  ${ var.teleport_discovery ? local.resources.discovery : ""}
  ${ var.teleport_db ? local.resources.rds : ""}
  ${ var.teleport_windows ? local.resources.rdp : ""}
  ${ var.teleport_app ? local.resources.aws : ""}
  ${local.resources.proxy}
  ${local.resources.end}
  ${local.commands.systemctl}
  EOF
}

resource "aws_instance" "teleport_agent" {
  count = var.create ? 1:0

  ami                    = local.ami.amzn_linux
  instance_type          = var.agent_instance_size
  subnet_id              = var.vpc_subnet_id
  vpc_security_group_ids = [var.vpc_security_group_id]

  associate_public_ip_address = var.vpc_public_ip
  key_name                    = var.aws_key_pair

  iam_instance_profile   = var.aws_instance_profile

  user_data_replace_on_change = true

  user_data = local_file.teleport_config[0].content

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
    instance_metadata_tags = "disabled"
  }

  root_block_device {
    encrypted = true
  }
  lifecycle {
    ignore_changes = [
      ami,
    ]
  }
}