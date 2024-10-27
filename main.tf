resource "random_string" "teleport_agent" {
  length  = 32
  special = false
}
resource "teleport_provision_token" "teleport_agent" {
  version = "v2"
  spec = {
    roles = var.teleport_agent_roles
  }
  metadata = {
    name    = random_string.teleport_agent.result
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

