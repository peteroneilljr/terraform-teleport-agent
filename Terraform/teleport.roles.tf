
resource "teleport_role" "join_sessions" {
  version = local.teleport.role_version
  metadata = {
    name        = "Join_Sessions"
    description = "Join Sessions Role"
    labels      = local.teleport.labels
  }

  spec = {

    allow = {
      rules = [
        {
          resources = [
            "session",     # Provides access to Session Recordings.
            "event",       # Determines whether a user can view the audit log
            "ssh_session", # allows seeing active sessions page
          ],
          verbs = [
            "*"
          ]
        }
      ]
      join_sessions = [ # Breaks when used with `create_host_user_mode`
        {
          name  = "join sessions"
          roles = ["*"]
          kinds = ["ssh"]
          modes = ["moderator", "observer", "peer"]
        }
      ]
    }
  }
}
resource "teleport_role" "agent_manager" {
  version = local.teleport.role_version
  metadata = {
    name        = "Agent_Manager"
    description = "Manage Teleport Agents Role"
    labels      = local.teleport.labels
  }

  spec = {
    allow = {
      logins = [
        "ubuntu",
        "ec2-user",
      ]

      node_labels = {
        "type" = ["agent"]
      }
    }
  }
}
resource "teleport_role" "requestor" {
  version = local.teleport.role_version
  metadata = {
    name        = "Requestor"
    description = "Request Resources Teleport Role"
    labels      = local.teleport.labels
  }

  spec = {
    allow = {
      request = {
        max_duration = "12h"
        roles = [
          teleport_role.admin.metadata.name,
          teleport_role.prod.metadata.name,
          teleport_role.resource_manager.metadata.name,
          teleport_role.agent_manager.metadata.name,
        ]
        search_as_roles = [
          teleport_role.admin.metadata.name,
        ]
      }
    }
  }
}
resource "teleport_role" "reviewer" {
  version = local.teleport.role_version
  metadata = {
    name        = "Reviewer"
    description = "Reviewer of Requests Teleport Role"
    labels      = local.teleport.labels
  }

  spec = {
    allow = {
      review_requests = {
        roles            = ["*"]
        preview_as_roles = [teleport_role.admin.metadata.name]
      }
    }
  }
}

resource "teleport_role" "resource_manager" {
  version = local.teleport.role_version
  metadata = {
    name        = "Resource_Manager"
    description = "Resource Manager Teleport Role"
    labels      = local.teleport.labels
  }

  spec = {
    allow = {
      rules = [
        {
          resources = [
            "*"
          ],
          verbs = [
            "*"
          ]
        }
      ]
    }
  }
}

