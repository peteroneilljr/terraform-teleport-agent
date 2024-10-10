resource "google_compute_instance" "teleport_agent" {
  count = var.create && var.cloud == "GCP" ? 1:0

  name         = "${var.prefix}-${var.agent_nodename}"
  machine_type = var.gcp_machine_type
  zone = "${var.gcp_region}-a"

  # tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      # labels = {
      #   my_label = "value"
      # }
    }
  }


  network_interface {
    network = "default"

    access_config {} # remove to make private
  }

  metadata_startup_script = local_file.teleport_config[0].content

  service_account {
    email  = var.gcp_service_account_email
    scopes = ["cloud-platform"]
  }
  lifecycle {
    ignore_changes = [
      metadata,
    ]
  }
}