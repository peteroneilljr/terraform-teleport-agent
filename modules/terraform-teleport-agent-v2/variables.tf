# ---------------------------------------------------------------------------- #
# VPC settings
# ---------------------------------------------------------------------------- #
variable "vpc_id" {
  type = string
}
variable "vpc_security_group_id" {
  type = string
}
variable "vpc_subnet_id" {
  type = string
}
variable "vpc_public_ip" {
  type        = bool
  description = "Assign public IP to this Agent's node"
  default     = false
}
# ---------------------------------------------------------------------------- #
# Agent settings
# ---------------------------------------------------------------------------- #
variable "agent_nodename" {
  type        = string
  description = "Name to appear in Teleport resource manager"
}
variable "agent_instance_size" {
  type        = string
  description = "AWS instance type to use"
  default     = "t3.nano"
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
  default     = "https://cdn.teleport.dev/install-v16.1.8.sh"
}
variable "teleport_version" {
  type        = string
  description = "Version of Teleport to install on each agent"
}
variable "teleport_app" {
  type        = bool
  description = "Enable App Type for Token"
  default     = false
}
variable "teleport_ssh_labels" {
  type        = map(string)
  description = "Teleport ssh labels"
  default     = {
    "iac" = "tofu"
  }
}
# ---------------------------------------------------------------------------- #
# Discovery
# ---------------------------------------------------------------------------- #
variable "teleport_discovery" {
  type        = bool
  description = "Enable Discovery Type for Token"
  default     = false
}
variable "teleport_discovery_tags" {
  type        = map(string)
  description = "Auto discovery tags to find ec2 instances."
  default = {}
}
variable "teleport_discovery_token" {
  type        = string
  description = "Discovery token used for nodes to self register"
  default = ""
}
variable "teleport_discovery_ssm_install" {
  type        = string
  description = "Discovery token used for nodes to self register"
  default = ""
}
# ---------------------------------------------------------------------------- #
# Windows
# ---------------------------------------------------------------------------- #
variable "teleport_windows" {
  type        = bool
  description = "Enable WindowsDesktop Type for Token"
  default     = false
}
variable "teleport_windows_hosts" {
  type = map(object({
      env  = string
      addr = string
  }))
  description = "Windows hosts to add"
  default = {}
}
# ---------------------------------------------------------------------------- #
# RDS
# ---------------------------------------------------------------------------- #
variable "teleport_db" {
  type        = bool
  description = "Enable Db Type for Token"
  default     = false
}
variable "teleport_rds_hosts" {
  type = map(object({
      env      = string
      endpoint = string
      address  = string
      admin    = string
      users    = list(string)
      password = string
      database = string
  }))
  description = "RDS connects to add to teleprot"
  default = {}
}
# ---------------------------------------------------------------------------- #
# Module settings
# ---------------------------------------------------------------------------- #
variable "create" {
  type        = bool
  description = "Boolean to disable module resources"
  default     = true
}
variable "prefix" {
  type        = string
  description = "String prefix to add to names"
  default     = ""
}