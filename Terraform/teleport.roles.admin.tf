resource "teleport_role" "admin" {
  version = local.teleport.role_version
  metadata = {
    name        = "Full_Admin"
    description = "Admin Teleport Role"
    labels      = local.teleport.labels
  }

  spec = {

    options = {
      # device_trust_mode     = "optional"
    }

    allow = {
      logins = [
        "root",
        "admin"
      ]

      node_labels = {
        "*" = ["*"]
      }
      app_labels = {
        "*" = ["*"]
      }
      db_labels = {
        "*" = ["*"]
      }
      kubernetes_labels = {
        "*" = ["*"]
      }

      kubernetes_groups = [
        "{{internal.kubernetes_groups}}",
        "system:masters"
      ]

      kubernetes_resources = [
        {
          "kind" : "*"
          "name" : "*"
          "namespace" : "*"
          "verbs" : ["*"]
        }
      ]
      windows_desktop_labels = {
        "*" = ["*"]
      }
      windows_desktop_logins = [
        "{{internal.windows_logins}}",
        "Administrator"
      ]
      aws_role_arns = [
        "{{internal.aws_role_arns}}",
        "arn:aws:iam::${var.aws_account_id}:role/${local.aws_role.admin}",
      ]
    }
  }
}