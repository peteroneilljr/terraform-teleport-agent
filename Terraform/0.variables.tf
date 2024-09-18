variable "aws_region" {
  type        = string
  description = "Region in which to deploy AWS resources"
}
variable "aws_account_id" {
  type        = string
  description = "Account ID for your AWS account, used in auto-discovery agents"
  default     = null
}
variable "aws_tags" {
  type        = map
  description = "Tags to add to AWS resources"
  default     = {}
}
variable "aws_teleport_profile" {
  type        = string
  description = "AWS Profile configured for roles anywhere with Teleport"
}
variable "teleport_proxy_address" {
  type        = string
  description = "Host and HTTPS port of the Teleport Proxy Service"
}
variable "teleport_identity_path" {
  type        = string
  description = "location of teleport identity file on host"
}
variable "teleport_user" {
  type        = string
  description = "username assgined in description for AWS resources"
}
variable "ssh_key_name" {
  type        = string
  description = "Name to give your AWS Key as SSH backup for demo"
  default     = ""
}
variable "teleport_version" {
  type        = string
  description = "Version of Teleport to install on each agent"
}
variable "teleport_cdn_link" {
  type        = string
  description = "Current CDN download link"
}
variable "github_client_secret" {
  type        = string
  description = "GitHub Oauth client_secret"
  sensitive   = true
}
variable "github_client_id" {
  type        = string
  description = "GitHub Oauth client_id"
}
variable "github_org" {
  type        = string
  description = "GitHub Organization Name"
}
