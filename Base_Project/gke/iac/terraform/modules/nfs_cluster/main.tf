resource "google_compute_instance" "gluster_instance" {
  count        = var.count 

  name         = "${var.gluster_name}-${count.index + 1}"
  machine_type = var.machine_type_instance
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.boot_disk_image
      size  = var.boot_disk_size
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnet
    access_config {} # Tạo IP công cộng
  }

  tags = [var.firewall_name]

  metadata = {
    ssh-keys = var.ssh_keys
  }
}

resource "google_compute_firewall" "firewall" {
  name        = var.firewall_name
  network     = var.network
  target_tags = [var.firewall_name]

  dynamic "allow" {
    for_each = var.allow_rules
    content {
      protocol = allow.value["protocol"]
      ports    = allow.value["ports"]
    }
  }

  source_ranges = var.source_ranges
}

data "template_file" "ansible_inventory" {
  template = <<EOF
[gluster_nodes]
%{ for instance in google_compute_instance.gluster_instance ~}
${instance.network_interface[0].access_config[0].nat_ip} ansible_user=${var.user_name} ansible_ssh_private_key_file=${var.private_key_path}
%{ endfor ~}
EOF
}

resource "local_file" "ansible_hosts" {
  content  = data.template_file.ansible_inventory.rendered
  filename = var.local_file_name
}
