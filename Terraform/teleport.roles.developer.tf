resource "teleport_role" "developer" {
  version = local.teleport.role_version
  metadata = {
    name        = "Developer"
    description = "Developer Teleport Role"
    labels      = local.teleport.labels
  }

  spec = {
    options = {
      device_trust_mode     = "required"
      create_host_user_mode = 3 # keep
    }

    allow = {
      logins = [
        "{{internal.logins}}",
        "ubuntu",
        "ec2-user"
      ]

      node_labels = {
        "env" = ["dev"]
      }
      app_labels = {
        "env" = ["dev"]
      }
      db_labels = {
        "env" = ["dev"]
      }
      db_service_labels = {
        "*" = ["*"]
      }
      db_names = ["*"]
      db_roles = [
        "{{internal.db_roles}}",
      ]
      db_users = [
        "{{internal.db_users}}",
        "developer",
      ]

      kubernetes_labels = {
        "env" = ["dev"]
      }
      kubernetes_groups = [
        "developers"
      ]
      windows_desktop_labels = {
        "env" = ["dev"]
      }

      windows_desktop_logins = [
        "{{internal.windows_logins}}"
      ]
      aws_role_arns = [
        "arn:aws:iam::${var.aws_account_id}:role/${local.aws_role.ro}",
        "arn:aws:iam::${var.aws_account_id}:role/${local.aws_role.ec2}",
      ]
      rules = [
        {
          resources = [
            "device" # to allow adding and removing device trust for demo
          ],
          verbs = [
            "*"
          ]
        },
        {
          resources = [
            "access_request" # delete current users access requests
          ],
          verbs = [
            "delete"
          ],
          # where = "contains(session.participants, user.metadata.name)" Need to figure out how where filters work
        }
      ]
    }
  }
}