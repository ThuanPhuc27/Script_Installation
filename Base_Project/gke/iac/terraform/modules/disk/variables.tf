variable "disk_name" {
  type        = string
}

variable "disk_type" {
  type        = string
  default     = "pd-standard"
}

variable "disk_size_gb" {
  type        = number
  default     = 10
}

variable "zone" {
  type        = string
} 