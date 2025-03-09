resource "google_compute_instance" "instance" {
  name         = var.instance_name
  machine_type = var.machine_type_instance
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.boot_disk_image
      size  = var.boot_disk_size
    }
  }

  network_interface {
    network = var.network
    subnetwork = var.subnet
    network_ip = var.internal_ip
    access_config {}
  }

  tags = [var.firewall_name]

  metadata = {
    ssh-keys = var.ssh_keys
  }

  metadata_startup_script = file("${path.root}/modules/instance/script.sh")

  provisioner "local-exec" {
    command = <<-EOT
      echo "[${var.instance_name}]" >> ${var.inventory_path}
      echo "${self.network_interface[0].access_config[0].nat_ip} ansible_user=${var.user_name} ansible_ssh_private_key_file=${var.private_key_path}" >> ${var.inventory_path}
    EOT
  } 
}

resource "google_compute_firewall" "firewall" {
  name          = var.firewall_name
  network       = var.network
  target_tags   = [var.firewall_name]

  dynamic "allow" {
    for_each = var.allow_rules  
    content {
      protocol = allow.value["protocol"]
      ports    = allow.value["ports"]
    }
  }

  source_ranges = var.source_ranges
}

resource "google_compute_disk" "additional_disk" {
  count = var.create_additional_disk ? 1 : 0 

  name = "persistent-disk-${var.instance_name}"
  size = var.disk_size
  type = var.disk_type
  zone = var.zone
  depends_on = [
    google_compute_instance.instance
  ]
}

resource "google_compute_attached_disk" "attach2VM" {
  count = var.create_additional_disk ? 1 : 0 

  disk     = google_compute_disk.additional_disk[0].id
  instance = google_compute_instance.instance.id
  zone     = var.zone
  depends_on = [
    google_compute_disk.additional_disk
  ]
}