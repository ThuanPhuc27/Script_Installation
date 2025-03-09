variable "project_id" {
  description = "Project ID for Google Cloud"
  type        = string
}

variable "region" {
  description = "Region for Google Cloud resources"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = null
}

variable "public_subnets" {
  description = "List of public subnets with name and CIDR"
  type = list(object({
    name  = string
    cidr  = string
  }))
}