resource "aws_key_pair" "peter" {
  key_name   = var.ssh_key_name
  public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
}