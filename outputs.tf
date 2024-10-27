output content {
  value       = module.teleport_gcp.local_file.teleport_config[0].content
  sensitive   = true
}
