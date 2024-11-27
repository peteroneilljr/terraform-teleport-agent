# ---------------------------------------------------------------------------- #
# AWS settings
# ---------------------------------------------------------------------------- #
variable "aws_vpc_id" {
  type    = string
  default = null
}
variable "aws_security_group_id" {
  type    = string
  default = ""
}
variable "aws_subnet_id" {
  type    = string
  default = null
}
variable "aws_key_pair" {
  type        = string
  description = "Name of AWS Key pair to assign to EC2 instance for direct SSH access"
  default     = null
}
variable "aws_instance_profile" {
  type        = string
  description = "Name of EC2 Instance profile"
  default     = null
}
variable "aws_tags" {
  description = "description"
  default     = {}
}
variable "aws_instance_size" {
  type        = string
  description = "AWS instance type to use"
  default     = "t3.small"
}

# ---------------------------------------------------------------------------- #
# Teleport settings
# ---------------------------------------------------------------------------- #
variable "teleport_proxy_address" {
  type        = string
  description = "Host and HTTPS port of the Teleport Proxy Service"
}
variable "teleport_cdn_address" {
  type        = string
  description = "Download script for Teleport"
  default     = "https://cdn.teleport.dev/install-v16.4.7.sh"
}
variable "teleport_version" {
  type        = string
  description = "Version of Teleport to install on each agent"
  default     = "16.4.7"
}
variable "teleport_edition" {
  type        = string
  description = "Edition of Teleport, cloud, enterprise or oss"
  default     = "cloud"
}
variable "teleport_enhanced_recording" {
  # https://goteleport.com/docs/enroll-resources/server-access/guides/bpf-session-recording/
  type        = bool
  default     = false
  description = "Enables enhanced recording on the Teleport Agent"
}
variable "teleport_fips" {
  # https://goteleport.com/docs/admin-guides/access-controls/compliance-frameworks/fedramp/
  type        = bool
  default     = false
  description = "Installs FIPS binary"
}
variable "teleport_node_name" {
  type        = string
  description = "Name to appear in Teleport resource manager"
}
variable "teleport_config_override" {
  type        = string
  description = "Override creation of the teleport config"
  default     = ""
}
variable "teleport_node_enable" {
  type        = bool
  default     = true
  description = "Register Agent as an SSH resource"
}
variable "teleport_agent_roles" {
  type        = list(string)
  default     = ["Node"]
  description = "Roles to enable on Teleport Agent, Node must be included for SSH"
}
variable "teleport_agent_packages" {
  type        = list(string)
  default     = []
  description = "Linux packages to install on Teleport Agent, e.g. postgresql15"
}
variable "teleport_node_labels" {
  type        = map(string)
  description = "Teleport labels for the Node"
  default = {
    "createdBy" = "IAC"
  }
}
# ---------------------------------------------------------------------------- #
# Discovery
# ---------------------------------------------------------------------------- #
variable "teleport_discovery_groups" {
  type = map(object({
    type              = string
    region            = string
    token_name        = string
    ssm_document_name = string
    tags              = map(string)
  }))
  description = "Discovery groups to add"
  default     = {}
}

# ---------------------------------------------------------------------------- #
# Windows
# ---------------------------------------------------------------------------- #

variable "teleport_windows_hosts" {
  type = map(object({
    addr   = string
    labels = map(string)
  }))
  description = "Windows hosts to add"
  default     = {}
}
# ---------------------------------------------------------------------------- #
# Apps
# ---------------------------------------------------------------------------- #

variable "teleport_apps" {
  type = map(object({
    uri    = optional(string, "")
    cloud  = optional(string, "")
    labels = optional(map(string), { "managed_by" = "iac" })
  }))
  description = "Apps to add"
  default     = {}
}

# ---------------------------------------------------------------------------- #
# DB
# ---------------------------------------------------------------------------- #

variable "teleport_databases" {
  type = map(object({
    description = string
    protocol    = string
    uri         = string
    labels      = map(string)
  }))
  description = "DB instances to add to add to teleprot"
  default     = {}
}


# ---------------------------------------------------------------------------- #
# Module settings
# ---------------------------------------------------------------------------- #

variable "prefix" {
  type        = string
  description = "String prefix to add to names"
  default     = ""
}
variable "public_ip" {
  type        = bool
  description = "Assign public IP to this Agent's node"
  default     = false
}
