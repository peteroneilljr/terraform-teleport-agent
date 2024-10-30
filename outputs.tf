output teleport_agent_public_ip {
  value       = try(aws_instance.teleport_agent.public_ip, "No public IP")
}
