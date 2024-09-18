resource "teleport_role" "prod" {
  version = local.teleport.role_version
  metadata = {
    name        = "Production_Admin"
    description = "Production Environment Teleport Role"
    labels      = local.teleport.labels
  }

  spec = {
    options = {
      # device_trust_mode     = "optional"
      create_host_user_mode = 3 # keep
    }

    allow = {
      logins = [
        "{{internal.logins}}",
        "production",
      ]

      node_labels = {
        "env" = ["prod"]
      }
      app_labels = {
        "env" = ["prod"]
      }
      db_labels = {
        "env" = ["prod"]
      }
      kubernetes_labels = {
        "env" = ["prod"]
      }
      windows_desktop_labels = {
        "env" = ["prod"]
      }
      kubernetes_groups = [
        "production"
      ]
      windows_desktop_logins = [
        "{{internal.windows_logins}}"
      ]
      aws_role_arns = [
        "arn:aws:iam::${var.aws_account_id}:role/${local.aws_role.net}",
        "arn:aws:iam::${var.aws_account_id}:role/${local.aws_role.db}",
      ]
    }
  }
}