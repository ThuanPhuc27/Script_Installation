resource "google_container_cluster" "gke_cluster" {
  name                     = var.cluster_name
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 2

  network    = var.vpc_name
  subnetwork = var.subnet_name
  deletion_protection = false 
  node_config {
    disk_type    = "pd-standard"
    disk_size_gb = var.disk_size_gb
  }
}

resource "google_container_node_pool" "gke_node_pool" {
  name       = "my-node-pool"
  location   = var.region
  cluster    = google_container_cluster.gke_cluster.name
  node_count = var.gke_num_nodes

  node_config {
    preemptible  = var.preemptible
    machine_type = var.machine_type_node
    disk_type    = "pd-standard"
    disk_size_gb = var.disk_size_gb
  }
}
