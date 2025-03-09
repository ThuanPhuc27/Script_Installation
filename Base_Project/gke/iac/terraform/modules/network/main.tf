# VPC
resource "google_compute_network" "gke_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

# Public Subnet
resource "google_compute_subnetwork" "public_subnet" {
  for_each = { for idx, subnet in var.public_subnets : subnet.name => subnet }

  name          = each.value.name
  region        = var.region
  network       = google_compute_network.gke_vpc.id
  ip_cidr_range = each.value.cidr
  private_ip_google_access = false
}

resource "google_compute_route" "public_route" {
  name       = "public-internet-route"
  network    = google_compute_network.gke_vpc.id
  dest_range = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
}
