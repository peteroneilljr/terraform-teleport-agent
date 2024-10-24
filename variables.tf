# ---------------------------------------------------------------------------- #
# AWS settings
# ---------------------------------------------------------------------------- #
variable "aws_vpc_id" {
  type = string
  default = null
}
variable "aws_security_group_id" {
  type = string
  default = ""
}
variable "aws_subnet_id" {
  type = string
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
variable "aws_ami_ubuntu" {
  type        = bool
  description = "Use Ubuntu AMI for Agent"
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
  default     = "https://cdn.teleport.dev/install-v16.2.0.sh"
}
variable "teleport_version" {
  type        = string
  description = "Version of Teleport to install on each agent"
}
variable "teleport_enhanced_recording" {
  # https://goteleport.com/docs/enroll-resources/server-access/guides/bpf-session-recording/
  type        = bool
  default     = false
  description = "Enables enhanced recording on the Teleport Agent"
}
variable "teleport_agent_roles" {
  type        = list(string)
  description = "Roles to enable on Teleport Agent, Node is already added by default"
}
variable "teleport_ssh_labels" {
  type        = map(string)
  description = "Teleport ssh labels"
  default     = {
    "createdBy" = "IAC"
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
  description = "EC2 Instances with these discovery tags will be auto-enrolled in Teleport."
  default = {}
}
variable "teleport_discovery_token" {
  type        = string
  description = "Long lived token used for nodes to self register"
  default = ""
}
variable "teleport_discovery_ssm_install" {
  type        = string
  description = "SSM document namedd container self registration script"
  default = ""
}
# ---------------------------------------------------------------------------- #
# Windows
# ---------------------------------------------------------------------------- #

variable "teleport_windows_hosts" {
  type = map(object({
      env  = string
      addr = string
  }))
  description = "Windows hosts to add"
  default = {}
}
# ---------------------------------------------------------------------------- #
# AWS
# ---------------------------------------------------------------------------- #

variable "teleport_aws_apps" {
  type = map(object({
      uri  = string
      labels = map(string)
  }))
  description = "AWS Appps to add"
  default = {}
}
# ---------------------------------------------------------------------------- #
# GCP
# ---------------------------------------------------------------------------- #

variable "teleport_gcp_apps" {
  type = map(object({
      labels    = map(string)
  }))
  description = "AWS Appps to add"
  default = {}
}
# ---------------------------------------------------------------------------- #
# RDS
# ---------------------------------------------------------------------------- #

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
variable "cloud" {
  type        = string
  description = "Cloud to deploy resources into"
  validation {
    condition     = contains(["AWS", "GCP"], var.cloud)
    error_message = "Valid values: AWS, GCP."
  } 
}
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
# ---------------------------------------------------------------------------- #
# GCP
# ---------------------------------------------------------------------------- #
variable "gcp_service_account_email" {
  type        = string
  description = "Service Account with ability to impersonate other service accounts"
  default = ""
}
variable "gcp_machine_type" {
  type        = string
  description = "Machine type for GCP VM Instance"
  default = "e2-micro"
}
variable "gcp_region" {
  type        = string
  description = "Region to deploy VM instance, zone is always -a"
  default = "us-central1"
}