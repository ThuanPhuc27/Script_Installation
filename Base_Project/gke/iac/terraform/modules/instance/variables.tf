variable "network" {
  description = "The network to which the instance will be attached"
  type        = string
}

# instance

variable "instance_name" {
  description = "The name of the instance"
  type        = string
}

variable "machine_type_instance" {
  description = "The machine type of the instance"
  type        = string
  default     = "e2-medium"

  validation {
    condition = contains(["e2-micro", "e2-small", "e2-medium", "n1-standard-1"], var.machine_type_instance)
    error_message = "Invalid machine type. Allowed values: e2-micro, e2-small, e2-medium, n1-standard-1."
  }
}

variable "zone" {
  description = "The zone where the instance will be created"
  type        = string
}

variable "subnet" {
  description = "The subnet where the instance will be created"
  type        = string
}

variable "internal_ip" {
  type        = string
  default     = null
}

variable "boot_disk_image" {
  description = "The boot disk image"
  type        = string
}

variable "boot_disk_size" {
  description = "The size of the boot disk"
  type        = number
  validation {
    condition     = var.boot_disk_size >= 10
    error_message = "The boot disk size must be at least 10GB."
  }
}

variable "ssh_keys" {
  description = "ssh keys"
  type        = string
}

variable "user_name" {
  description = "The user name for SSH access"
  type        = string
}

variable "inventory_path" {
  description = "Inventory path"
  type        = string
}

variable "private_key_path" {
  description = "private key path"
  type        = string
}


# firewall

variable "firewall_name" {
  description = "The name of the firewall"
  type        = string
}

variable "allow_rules" {
  type = list(object({
    protocol = string
    ports    = list(string)
  }))

  default = [{
    protocol = "tcp"
    ports    = ["22"]
  }]
}

variable "source_ranges" {
  type = list(string)

  validation {
    condition     = length(var.source_ranges) > 0
    error_message = "At least one source range must be specified."
  }
}

# additional_disk

variable "create_additional_disk" {
  description = "Flag to create and attach an additional disk to the instance"
  type        = bool
  default     = false  # Có thể đặt mặc định là true hoặc false tùy ý
}

variable "disk_type" {
  type        = string
  description = "The additional_disk_type of the VM."
  default     = "pd-ssd"
}

variable "disk_size" {
  type        = number
  description = "The addtnl_disk_size of the VM."
  default     = 10
}