resource "aws_instance" "teleport_agent" {
  count = var.create && var.cloud == "AWS" ? 1:0

  ami                    = var.aws_ami_ubuntu ? local.ami.ubuntu : local.ami.amzn_linux
  instance_type          = var.agent_instance_size
  subnet_id              = var.aws_subnet_id
  vpc_security_group_ids = [var.aws_security_group_id]

  associate_public_ip_address = var.public_ip
  key_name                    = var.aws_key_pair

  iam_instance_profile   = var.aws_instance_profile

  user_data_replace_on_change = true

  user_data = local_file.teleport_config[0].content

  tags = var.aws_tags

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
    instance_metadata_tags = "disabled"
  }

  root_block_device {
    encrypted = true
  }
  lifecycle {
    ignore_changes = [
      ami,
    ]
  }
}