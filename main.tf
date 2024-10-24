resource "random_string" "teleport_agent" {
  count = var.create ? 1:0

  length  = 32
  special = false
}
resource "teleport_provision_token" "teleport_agent" {
  count = var.create ? 1:0

  version = "v2"
  spec = {
    roles = flatten([
        [
          "Node",
        ],
        var.teleport_agent_roles,
      ]
    )
  }
  metadata = {
    name = random_string.teleport_agent[count.index].result
    expires = timeadd(timestamp(), "4h")

    labels = {
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
  ${ local.commands.shell}
  ${ local.commands.usershell}
  ${ local.commands.token}
  ${ local.commands.hostname}
  ${ local.install.teleport}
  ${ length(var.teleport_rds_hosts) > 0 ? local.install.rds : "" }
  ${ local.resources.start}
  ${ local.resources.ssh}
  ${ var.teleport_discovery ? local.resources.discovery : ""}
  ${ length(var.teleport_rds_hosts) > 0 ? local.resources.rds : ""}
  ${ length(var.teleport_windows_hosts) > 0 ? local.resources.rdp : ""}
  ${ length(var.teleport_aws_apps) > 0 ? local.resources.aws : ""}
  ${ length(var.teleport_gcp_apps) > 0 ? local.resources.gcp : ""}
  ${ local.resources.proxy}
  ${ local.resources.end}
  ${ local.commands.systemctl}
  EOF
}
