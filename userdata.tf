data "cloudinit_config" "teleport_cluster_config" {
  # https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config
  gzip          = false
  base64_encode = false


  part {
    content_type = "text/cloud-config"
    content      = var.teleport_config_override != "" ? local.teleport_config_override : local.teleport-config-yaml
  }
  part {
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/configs/teleport-cloud-init.yaml",
      {
        teleport_version        = var.teleport_version
        teleport_node_name      = var.teleport_node_name
        teleport_agent_packages = var.teleport_agent_packages
        teleport_fips           = var.teleport_fips
        teleport_system_arch    = "amd64"
      }
    )
  }
}

locals {
  teleport_config_override = templatefile(
    "${path.module}/configs/teleport-config-override.yaml",
    {
      teleport_config_override = var.teleport_config_override
      teleport_auth_token      = teleport_provision_token.teleport_agent.metadata.name
    }
  )

  teleport_config = templatefile(
    "${path.module}/configs/teleport-config.yaml",
    {
      teleport_proxy_address = var.teleport_proxy_address
      teleport_node_name     = var.teleport_node_name
      teleport_auth_token    = teleport_provision_token.teleport_agent.metadata.name
    }
  )

  ssh_service = var.teleport_node_enable ? templatefile(
    "${path.module}/configs/ssh_service.yaml",
    {
      teleport_node_labels = var.teleport_node_labels
    }
  ) : ""

  app_service = length(var.teleport_apps) > 0 ? templatefile(
    "${path.module}/configs/app_service.yaml",
    {
      teleport_apps = var.teleport_apps
    }
  ) : ""

  db_service = length(var.teleport_databases) > 0 ? templatefile(
    "${path.module}/configs/db_service.yaml",
    {
      teleport_databases = var.teleport_databases
    }
  ) : ""

  discovery_service = length(var.teleport_discovery_groups) > 0 ? templatefile(
    "${path.module}/configs/discovery_service.yaml",
    {
      teleport_discovery_groups = var.teleport_discovery_groups
    }
  ) : ""

  windows_desktop_service = length(var.teleport_windows_hosts) > 0 ? templatefile(
    "${path.module}/configs/windows_desktop_service.yaml",
    {
      teleport_windows_hosts = var.teleport_windows_hosts
    }
  ) : ""


}


locals {
  teleport-config-yaml = join("\n",
    [
      local.teleport_config,
      local.ssh_service,
      local.app_service,
      local.db_service,
      local.discovery_service,
      local.windows_desktop_service
    ]
  )
}
