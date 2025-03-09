output "instance_ip" {
  description = "The public IP of the instance"
  value       = google_compute_instance.instance.network_interface[0].access_config[0].nat_ip
}

output "internal_ip" {
  description = "The internal IP of the instance"
  value       = google_compute_instance.instance.network_interface[0].network_ip
}

output "disk_name" {
  value = length(google_compute_disk.additional_disk) > 0 ? google_compute_disk.additional_disk[0].name : "No disk attached"
}

output "disk_self_link" {
  value = length(google_compute_disk.additional_disk) > 0 ? google_compute_disk.additional_disk[0].self_link : "No disk attached"
}
