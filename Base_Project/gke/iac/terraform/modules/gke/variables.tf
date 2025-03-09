variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "region" {
  description = "The region for GKE cluster"
  type        = string
}

variable "machine_type_node" {
  description = "Machine type for GKE nodes"
  type        = string
}

variable "gke_num_nodes" {
  description = "Number of nodes in the GKE cluster"
  default     = 1
  type        = number
}

variable "disk_size_gb" {
  description = "Disk size for GKE nodes in GB"
  default     = 50
  type        = number
}

variable "preemptible" {
  description = "Whether the GKE nodes should be preemptible"
  default     = true
  type        = bool
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = null
}

variable "subnet_name" {
  description = "Name of the Subnet"
  type        = string
  default     = null
}
