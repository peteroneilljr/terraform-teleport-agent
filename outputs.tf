output "teleport_agent_public_ip" {
  value = try(aws_instance.teleport_agent.public_ip, "No public IP")
}

data "aws_instance" "teleport_agent" {
  instance_id = aws_instance.teleport_agent.id
  get_user_data = true
}
output teleport_startup_script {
  value       = base64decode(data.aws_instance.teleport_agent.user_data_base64)
  sensitive = true
}
