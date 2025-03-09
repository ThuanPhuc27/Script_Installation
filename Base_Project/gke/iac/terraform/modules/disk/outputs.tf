output "disk_name" {
  value       = google_compute_disk.persistent_disk.name
}

output "disk_self_link" {
  value       = google_compute_disk.persistent_disk.self_link
}
