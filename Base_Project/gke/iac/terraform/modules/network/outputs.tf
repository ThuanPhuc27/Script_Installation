output "vpc_name" {
  description = "The name of the VPC"
  value       = google_compute_network.gke_vpc.name
}

output "public_subnet_names" {
  description = "The names of the public subnets"
  value       = [for subnet in google_compute_subnetwork.public_subnet : subnet.name]
}

# Output CIDR của các public subnet
output "public_subnet_cidrs" {
  description = "The CIDR blocks of the public subnets"
  value       = [for subnet in google_compute_subnetwork.public_subnet : subnet.ip_cidr_range]
}