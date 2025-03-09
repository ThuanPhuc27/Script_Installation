################################################################################
# VPC Module - Output 
################################################################################

output "vpc_name" {
  description = "The name of the created VPC"
  value       = module.network.vpc_name
}

output "public_subnet_names" {
  description = "The name of the created Subnet"
  value       = module.network.public_subnet_names
}

output "public_subnet_cidrs" {
  description = "The CIDR range of the created Subnet"
  value       = module.network.public_subnet_cidrs
}

################################################################################
# GKE Cluster Module - Output 
################################################################################

output "gke_cluster_name" {
  value = module.gke.gke_cluster_name
}

output "gke_cluster_endpoint" {
  value = module.gke.gke_cluster_endpoint
}

output "gke_cluster_ca_certificate" {
  value = module.gke.gke_cluster_ca_certificate
}

################################################################################
# Load Balancing Instance Module - Variables 
################################################################################
output "load_balancing_ip" {
  description = "The public IP of the instance"
  value       = module.load_balancing.instance_ip
}

output "load_balancing_internal_ip" {
  description = "The internal IP of the instance"
  value       = module.load_balancing.internal_ip
}


output "load_balancing_persistent_disk_name" {
  value = module.load_balancing.disk_name
  description = "The name of the persistent disk."
}

################################################################################
# Jenkins Instance Module - Output 
################################################################################

output "jenkins_instance_ip" {
  description = "The public IP of the instance"
  value       = module.jenkins_instance.instance_ip
}

output "jenkins_internal_ip" {
  description = "The internal IP of the instance"
  value       = module.jenkins_instance.internal_ip
}

output "jenkins_persistent_disk_name" {
  value = module.jenkins_instance.disk_name
  description = "The name of the persistent disk."
}

################################################################################
# Rancher Instance Module - Output 
################################################################################

output "rancher_instance_ip" {
  description = "The public IP of the instance"
  value       = module.rancher_instance.instance_ip
}

output "rancher_internal_ip" {
  description = "The internal IP of the instance"
  value       = module.rancher_instance.internal_ip
}

output "rancher_persistent_disk_name" {
  value = module.rancher_instance.disk_name
  description = "The name of the persistent disk."
}

output "rancher_disk_self_link" {
  value = module.rancher_instance.disk_self_link
  description = "The self link of the persistent disk."
}

################################################################################
# Nexus Instance Module - Output 
################################################################################

output "nexus_instance_ip" {
  description = "The public IP of the instance"
  value       = module.nexus_instance.instance_ip
}


output "nexus_internal_ip" {
  description = "The internal IP of the instance"
  value       = module.nexus_instance.internal_ip
}

output "nexus_persistent_disk_name" {
  value = module.nexus_instance.disk_name
  description = "The name of the persistent disk."
}

output "nexus_disk_self_link" {
  value = module.nexus_instance.disk_self_link
  description = "The self link of the persistent disk."
}

################################################################################
# Vault Instance Module - Output 
################################################################################

output "vault_instance_ip" {
  description = "The public IP of the instance"
  value       = module.vault_instance.instance_ip
}

output "vault_internal_ip" {
  description = "The internal IP of the instance"
  value       = module.vault_instance.internal_ip
}

output "vault_persistent_disk_name" {
  value = module.vault_instance.disk_name
  description = "The name of the persistent disk."
}

output "vault_disk_self_link" {
  value = module.vault_instance.disk_self_link
  description = "The self link of the persistent disk."
}