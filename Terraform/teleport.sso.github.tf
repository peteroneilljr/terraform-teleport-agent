resource "teleport_github_connector" "github" {
  version = "v3"
  metadata = {
    name = "github"
  }

  spec = {
    client_id     = var.github_client_id
    client_secret = var.github_client_secret

    redirect_url     = "https://${var.teleport_proxy_address}:443/v1/webapi/github/callback"
    endpoint_url     = "https://github.com"
    api_endpoint_url = "https://api.github.com"

    teams_to_roles = [
      {
        organization = var.github_org
        team         = "developers"
        roles = [
          teleport_role.developer.metadata.name,
          teleport_role.requestor.metadata.name,
          teleport_role.join_sessions.metadata.name,
        ]
      },
      {
        organization = var.github_org
        team         = "admins"
        roles = [
          teleport_role.admin.metadata.name,
          teleport_role.reviewer.metadata.name,
          teleport_role.resource_manager.metadata.name,
        ]
      }
    ]
  }
}
