output content {
  value       = local_file.teleport_config[0].content
  sensitive   = true
}
