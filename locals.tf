locals {
  ami = {
    ubuntu = try(data.aws_ami.ubuntu[0].id, null)
    amzn_linux = try(data.aws_ami.amzn_linux[0].id, null)
  }
}

data "aws_ami" "amzn_linux" {
  count = var.create ? 1:0
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

data "aws_ami" "ubuntu" {
  count = var.create ? 1:0
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