# ---------------------------------------------------------------------------- #
# Cluster controls to enable resources
# ---------------------------------------------------------------------------- #
locals {
  prefix = "Pon"
  teleport = {
    ssh            = true
    rdp            = false
    aws            = true
    rds            = true
    auto_discovery = false
    role_version   = "v7"
    user_version   = "v2"
    labels = {
      iac = "tofu"
    }
  }
}
# ---------------------------------------------------------------------------- #
# Teleport locals
# ---------------------------------------------------------------------------- #
locals {
  aws_role = {
    console = "PonAwsConsoleAccess"
    ro      = "PonAwsAssumeReadOnly"
    admin   = "PonAwsAssumeAdmin"
    db      = "PonAwsAssumeDatabaseAdmin"
    net     = "PonAwsAssumeNetworkAdmin"
    ec2     = "PonAwsAssumeEc2Admin"
  }
}
# ---------------------------------------------------------------------------- #
# AMI Lookups
# ---------------------------------------------------------------------------- #
locals {
  ami = {
    ubuntu : data.aws_ami.ubuntu.id
    amzn_linux : data.aws_ami.amzn_linux.id
    windows : data.aws_ami.windows.id
  }
}
data "aws_ami" "ubuntu" {
  owners      = ["099720109477"] # Canonical
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
data "aws_ami" "amzn_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}
data "aws_ami" "windows" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }

  filter {
    name   = "platform"
    values = ["windows"]
  }
}
