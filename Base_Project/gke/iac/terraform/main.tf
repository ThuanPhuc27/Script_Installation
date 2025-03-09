provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("admin_gke.json")
}

module "network" {
  source          = "./modules/network"  
  project_id      = var.project_id       
  region          = var.region          
  vpc_name        = var.vpc_name     
  public_subnets  = var.public_subnets
}

module "gke" {
  source               = "./modules/gke"
  depends_on           = [module.network]

  region               = var.region
  vpc_name             = module.network.vpc_name
  subnet_name          = module.network.public_subnet_names[0]

  cluster_name         = var.cluster_name
  machine_type_node    = var.machine_type_node
  gke_num_nodes        = var.gke_num_nodes
  disk_size_gb         = var.disk_size_gb
  preemptible          = var.preemptible

} 

module "load_balancing" {
  source               = "./modules/instance"
  depends_on = [module.network]

  instance_name        = var.lb_instance_name
  machine_type_instance = var.lb_machine_type_instance
  zone                 = var.lb_zone
  network              = module.network.vpc_name
  subnet               = module.network.public_subnet_names[1]
  internal_ip          = var.lb_internal_ip
  boot_disk_image      = var.lb_boot_disk_image
  boot_disk_size       = var.lb_boot_disk_size
  ssh_keys             = "${var.lb_user_name}:${file("./id_rsa.pub")}"

  user_name            = var.lb_user_name
  inventory_path       = var.inventory_path
  private_key_path     = var.private_key_path

  firewall_name        = var.lb_firewall_name
  allow_rules          = var.lb_allow_rules
  source_ranges        = var.lb_source_ranges

  create_additional_disk  = var.lb_create_additional_disk
}  

module "jenkins_instance" {
  source               = "./modules/instance"
  depends_on = [module.network]

  instance_name        = var.jk_instance_name
  machine_type_instance = var.jk_machine_type_instance
  zone                 = var.jk_zone
  network              = module.network.vpc_name
  subnet               = module.network.public_subnet_names[1]
  internal_ip          = var.jk_internal_ip
  boot_disk_image      = var.jk_boot_disk_image
  boot_disk_size       = var.jk_boot_disk_size
  ssh_keys             = "${var.jk_user_name}:${file("./id_rsa.pub")}"

  user_name            = var.jk_user_name
  inventory_path       = var.inventory_path
  private_key_path     = var.private_key_path

  firewall_name        = var.jk_firewall_name
  allow_rules          = var.jk_allow_rules
  source_ranges        = var.jk_source_ranges

  create_additional_disk  = var.jk_create_additional_disk
}  

module "rancher_instance" {
  source               = "./modules/instance"
  depends_on = [module.network]

  instance_name        = var.rancher_instance_name
  machine_type_instance = var.rancher_machine_type_instance
  zone                 = var.rancher_zone
  network              = module.network.vpc_name
  subnet               = module.network.public_subnet_names[1]
  internal_ip          = var.rancher_internal_ip
  boot_disk_image      = var.rancher_boot_disk_image
  boot_disk_size       = var.rancher_boot_disk_size
  ssh_keys             = "${var.rancher_user_name}:${file("./id_rsa.pub")}"

  user_name            = var.rancher_user_name
  inventory_path       = var.inventory_path
  private_key_path     = var.private_key_path

  firewall_name        = var.rancher_firewall_name
  allow_rules          = var.rancher_allow_rules
  source_ranges        = var.rancher_source_ranges

  create_additional_disk  = var.rancher_create_additional_disk
  disk_type               = var.rancher_disk_type
  disk_size               = var.rancher_disk_size
}  


module "nexus_instance" {
  source               = "./modules/instance"
  depends_on = [module.network]

  instance_name        = var.nexus_instance_name
  machine_type_instance = var.nexus_machine_type_instance
  zone                 = var.nexus_zone
  network              = module.network.vpc_name
  subnet               = module.network.public_subnet_names[1]
  internal_ip          = var.nexus_internal_ip
  boot_disk_image      = var.nexus_boot_disk_image
  boot_disk_size       = var.nexus_boot_disk_size
  ssh_keys             = "${var.nexus_user_name}:${file("./id_rsa.pub")}"

  user_name            = var.nexus_user_name
  inventory_path       = var.inventory_path
  private_key_path     = var.private_key_path

  firewall_name        = var.nexus_firewall_name
  allow_rules          = var.nexus_allow_rules
  source_ranges        = var.nexus_source_ranges

  create_additional_disk  = var.nexus_create_additional_disk
  disk_type               = var.nexus_disk_type
  disk_size               = var.nexus_disk_size
}  


module "vault_instance" {
  source               = "./modules/instance"
  depends_on = [module.network]

  instance_name        = var.vault_instance_name
  machine_type_instance = var.vault_machine_type_instance
  zone                 = var.vault_zone
  network              = module.network.vpc_name
  subnet               = module.network.public_subnet_names[1]
  internal_ip          = var.vault_internal_ip
  boot_disk_image      = var.vault_boot_disk_image
  boot_disk_size       = var.vault_boot_disk_size
  ssh_keys             = "${var.vault_user_name}:${file("./id_rsa.pub")}"

  user_name            = var.vault_user_name
  inventory_path       = var.inventory_path
  private_key_path     = var.private_key_path

  firewall_name        = var.vault_firewall_name
  allow_rules          = var.vault_allow_rules
  source_ranges        = var.vault_source_ranges

  create_additional_disk  = var.vault_create_additional_disk
  disk_type               = var.vault_disk_type
  disk_size               = var.vault_disk_size
}  

