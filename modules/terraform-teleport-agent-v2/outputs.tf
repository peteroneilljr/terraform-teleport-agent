output "teleport_conf" {
  value = var.create ? local_file.teleport_config[0].content : null
}