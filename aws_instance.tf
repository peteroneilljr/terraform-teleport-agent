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

resource "aws_instance" "teleport_agent" {

  ami                    = data.aws_ami.amzn_linux.id
  instance_type          = var.aws_instance_size
  subnet_id              = var.aws_subnet_id
  vpc_security_group_ids = [var.aws_security_group_id]

  associate_public_ip_address = var.public_ip
  key_name                    = var.aws_key_pair

  iam_instance_profile = var.aws_instance_profile

  user_data_replace_on_change = true

  user_data = data.cloudinit_config.teleport_cluster_config.rendered

  tags = var.aws_tags

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "required"
    instance_metadata_tags = "disabled"
  }

  root_block_device {
    encrypted = true
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      ami,
    ]
  }
}