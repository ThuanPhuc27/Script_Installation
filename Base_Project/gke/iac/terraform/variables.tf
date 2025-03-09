variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
  default     = "online-boutique-449209"
}

variable "region" {
  description = "Google Cloud Region"
  type        = string
  default     = "asia-southeast1"
}

################################################################################
# Network Module - Variables 
################################################################################

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "gke-vpc" 
}

variable "public_subnets" {
  description = "List of public subnets with name and CIDR"
  type = list(object({
    name  = string
    cidr  = string
  }))
  default = [
    { name = "public-gke-subnet", cidr = "10.0.1.0/24" },
    { name = "public-subnet", cidr = "10.0.2.0/24" }
  ]
}

################################################################################
# GKE Module - Variables 
################################################################################

variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = "online-boutique-gke" 
}

variable "machine_type_node" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-standard-2" // 2 vCPUs, 8 GB RAM
}

variable "gke_num_nodes" {
  description = "Number of nodes in the GKE cluster"
  type        = number
  default     = 1
}

variable "disk_size_gb" {
  description = "Disk size for GKE nodes in GB"
  type        = number
  default     = 30
}

variable "preemptible" {
  description = "Whether the GKE nodes should be preemptible"
  type        = bool
  default     = true
}

################################################################################
# Ansible - Variables 
################################################################################

variable "inventory_path" {
  description = "Inventory path"
  type        = string
}

variable "private_key_path" {
  description = "private key path"
  type        = string
}

################################################################################
# Load Balancing Instance Module - Variables 
################################################################################


variable "lb_instance_name" {
  description = "The name of the instance"
  type        = string
}

variable "lb_machine_type_instance" {
  description = "The machine type of the instance"
  type        = string
  default     = "e2-medium"

  validation {
    condition = contains(["e2-micro", "e2-small", "e2-medium", "n1-standard-1"], var.lb_machine_type_instance)
    error_message = "Invalid machine type. Allowed values: e2-micro, e2-small, e2-medium, n1-standard-1."
  }
}

variable "lb_zone" {
  description = "The zone where the instance will be created"
  type        = string
}

variable "lb_internal_ip" {
  type        = string
  default     = null
}

variable "lb_boot_disk_image" {
  description = "The boot disk image"
  type        = string
}

variable "lb_boot_disk_size" {
  description = "The size of the boot disk"
  type        = number
  validation {
    condition     = var.lb_boot_disk_size >= 10
    error_message = "The boot disk size must be at least 10GB."
  }
}

variable "lb_user_name" {
  description = "The user name for SSH access"
  type        = string
}

# firewall

variable "lb_firewall_name" {
  description = "The name of the firewall"
  type        = string
}

variable "lb_allow_rules" {
  type = list(object({
    protocol = string
    ports    = list(string)
  }))

  default = [{
    protocol = "tcp"
    ports    = ["22"]
  }]
}

variable "lb_source_ranges" {
  type = list(string)

  validation {
    condition     = length(var.lb_source_ranges) > 0
    error_message = "At least one source range must be specified."
  }
}

# additional_disk

variable "lb_create_additional_disk" {
  description = "Flag to create and attach an additional disk to the instance"
  type        = bool
  default     = false  
}


################################################################################
# Jenkins Instance Module - Variables 
################################################################################

variable "jk_instance_name" {
  description = "The name of the instance"
  type        = string
}

variable "jk_machine_type_instance" {
  description = "The machine type of the instance"
  type        = string
  default     = "e2-medium"

  validation {
    condition = contains(["e2-micro", "e2-small", "e2-medium", "n1-standard-1"], var.jk_machine_type_instance)
    error_message = "Invalid machine type. Allowed values: e2-micro, e2-small, e2-medium, n1-standard-1."
  }
}

variable "jk_zone" {
  description = "The zone where the instance will be created"
  type        = string
}

variable "jk_internal_ip" {
  type        = string
  default     = null
}

variable "jk_boot_disk_image" {
  description = "The boot disk image"
  type        = string
}

variable "jk_boot_disk_size" {
  description = "The size of the boot disk"
  type        = number
  validation {
    condition     = var.jk_boot_disk_size >= 10
    error_message = "The boot disk size must be at least 10GB."
  }
}

variable "jk_user_name" {
  description = "The user name for SSH access"
  type        = string
}

# firewall

variable "jk_firewall_name" {
  description = "The name of the firewall"
  type        = string
}

variable "jk_allow_rules" {
  type = list(object({
    protocol = string
    ports    = list(string)
  }))

  default = [{
    protocol = "tcp"
    ports    = ["22"]
  }]
}

variable "jk_source_ranges" {
  type = list(string)

  validation {
    condition     = length(var.jk_source_ranges) > 0
    error_message = "At least one source range must be specified."
  }
}

# additional_disk

variable "jk_create_additional_disk" {
  description = "Flag to create and attach an additional disk to the instance"
  type        = bool
  default     = false  
}

################################################################################
# Rancher Instance Module - Variables 
################################################################################

variable "rancher_instance_name" {
  description = "The name of the instance"
  type        = string
}

variable "rancher_machine_type_instance" {
  description = "The machine type of the instance"
  type        = string
  default     = "e2-medium"

  validation {
    condition = contains(["e2-micro", "e2-small", "e2-medium", "n1-standard-1"], var.rancher_machine_type_instance)
    error_message = "Invalid machine type. Allowed values: e2-micro, e2-small, e2-medium, n1-standard-1."
  }
}

variable "rancher_zone" {
  description = "The zone where the instance will be created"
  type        = string
}

variable "rancher_internal_ip" {
  type        = string
  default     = null
}

variable "rancher_boot_disk_image" {
  description = "The boot disk image"
  type        = string
}

variable "rancher_boot_disk_size" {
  description = "The size of the boot disk"
  type        = number
  validation {
    condition     = var.rancher_boot_disk_size >= 10
    error_message = "The boot disk size must be at least 10GB."
  }
}

variable "rancher_user_name" {
  description = "The user name for SSH access"
  type        = string
}

# firewall

variable "rancher_firewall_name" {
  description = "The name of the firewall"
  type        = string
}

variable "rancher_allow_rules" {
  type = list(object({
    protocol = string
    ports    = list(string)
  }))

  default = [{
    protocol = "tcp"
    ports    = ["22"]
  }]
}

variable "rancher_source_ranges" {
  type = list(string)

  validation {
    condition     = length(var.rancher_source_ranges) > 0
    error_message = "At least one source range must be specified."
  }
}

# additional_disk

variable "rancher_create_additional_disk" {
  description = "Flag to create and attach an additional disk to the instance"
  type        = bool
  default     = false  
}

variable "rancher_disk_type" {
  type        = string
  description = "The additional_disk_type of the VM."
  default     = "pd-ssd"
}

variable "rancher_disk_size" {
  type        = number
  description = "The addtnl_disk_size of the VM."
  default     = 10
}

################################################################################
# Nexus Instance Module - Variables 
################################################################################

variable "nexus_instance_name" {
  description = "The name of the instance"
  type        = string
}

variable "nexus_machine_type_instance" {
  description = "The machine type of the instance"
  type        = string
  default     = "e2-medium"

  validation {
    condition = contains(["e2-micro", "e2-small", "e2-medium", "n1-standard-1"], var.nexus_machine_type_instance)
    error_message = "Invalid machine type. Allowed values: e2-micro, e2-small, e2-medium, n1-standard-1."
  }
}

variable "nexus_zone" {
  description = "The zone where the instance will be created"
  type        = string
}

variable "nexus_internal_ip" {
  type        = string
  default     = null
}

variable "nexus_boot_disk_image" {
  description = "The boot disk image"
  type        = string
}

variable "nexus_boot_disk_size" {
  description = "The size of the boot disk"
  type        = number
  validation {
    condition     = var.nexus_boot_disk_size >= 10
    error_message = "The boot disk size must be at least 10GB."
  }
}

variable "nexus_user_name" {
  description = "The user name for SSH access"
  type        = string
}

# firewall

variable "nexus_firewall_name" {
  description = "The name of the firewall"
  type        = string
}

variable "nexus_allow_rules" {
  type = list(object({
    protocol = string
    ports    = list(string)
  }))

  default = [{
    protocol = "tcp"
    ports    = ["22"]
  }]
}

variable "nexus_source_ranges" {
  type = list(string)

  validation {
    condition     = length(var.nexus_source_ranges) > 0
    error_message = "At least one source range must be specified."
  }
}

# additional_disk

variable "nexus_create_additional_disk" {
  description = "Flag to create and attach an additional disk to the instance"
  type        = bool
  default     = false  
}

variable "nexus_disk_type" {
  type        = string
  description = "The additional_disk_type of the VM."
  default     = "pd-ssd"
}

variable "nexus_disk_size" {
  type        = number
  description = "The addtnl_disk_size of the VM."
  default     = 10
}


################################################################################
# Vault Instance Module - Variables 
################################################################################

variable "vault_instance_name" {
  description = "The name of the instance"
  type        = string
}

variable "vault_machine_type_instance" {
  description = "The machine type of the instance"
  type        = string
  default     = "e2-medium"

  validation {
    condition = contains(["e2-micro", "e2-small", "e2-medium", "n1-standard-1"], var.vault_machine_type_instance)
    error_message = "Invalid machine type. Allowed values: e2-micro, e2-small, e2-medium, n1-standard-1."
  }
}

variable "vault_zone" {
  description = "The zone where the instance will be created"
  type        = string
}

variable "vault_internal_ip" {
  type        = string
  default     = null
}

variable "vault_boot_disk_image" {
  description = "The boot disk image"
  type        = string
}

variable "vault_boot_disk_size" {
  description = "The size of the boot disk"
  type        = number
  validation {
    condition     = var.vault_boot_disk_size >= 10
    error_message = "The boot disk size must be at least 10GB."
  }
}

variable "vault_user_name" {
  description = "The user name for SSH access"
  type        = string
}

# firewall

variable "vault_firewall_name" {
  description = "The name of the firewall"
  type        = string
}

variable "vault_allow_rules" {
  type = list(object({
    protocol = string
    ports    = list(string)
  }))

  default = [{
    protocol = "tcp"
    ports    = ["22"]
  }]
}

variable "vault_source_ranges" {
  type = list(string)

  validation {
    condition     = length(var.vault_source_ranges) > 0
    error_message = "At least one source range must be specified."
  }
}

# additional_disk

variable "vault_create_additional_disk" {
  description = "Flag to create and attach an additional disk to the instance"
  type        = bool
  default     = false  
}

variable "vault_disk_type" {
  type        = string
  description = "The additional_disk_type of the VM."
  default     = "pd-ssd"
}

variable "vault_disk_size" {
  type        = number
  description = "The addtnl_disk_size of the VM."
  default     = 10
}