project_id = "online-boutique-449209"

region = "asia-southeast1"

################################################################################
# Network Module - Variables 
################################################################################

vpc_name = "gke-vpc" 

public_subnets =  [
    { name = "public-gke-subnet", cidr = "10.0.1.0/24" },
    { name = "public-subnet", cidr = "10.0.2.0/24" }
  ]

################################################################################
# GKE Module - Variables 
################################################################################

cluster_name = "online-boutique-gke" 

machine_type_node = "e2-standard-2" 
 
gke_num_nodes = 2

disk_size_gb = 30

preemptible = false

################################################################################
# Ansible - Variables 
################################################################################

inventory_path = "../ansible/inventories/hosts.ini"

private_key_path = "~/.ssh/id_rsa"

################################################################################
# Load Balancing Instance Module - Variables 
################################################################################
lb_instance_name = "load-balancing"

lb_machine_type_instance = "e2-medium"

lb_zone = "asia-southeast1-b"

lb_internal_ip = "10.0.2.2"

lb_boot_disk_image = "ubuntu-os-cloud/ubuntu-2004-lts"  

lb_boot_disk_size = 50

lb_user_name = "root"

lb_firewall_name = "lb-firewall"

lb_allow_rules = [
  {
    protocol = "tcp"
    ports    = ["22"]
  },
  {
    protocol = "tcp"
    ports    = ["80"]
  },
  {
    protocol = "tcp"
    ports    = ["443"]
  },
]

lb_source_ranges = ["0.0.0.0/0"]

lb_create_additional_disk = false

################################################################################
# Jenkins Instance Module - Variables 
################################################################################

jk_instance_name = "jenkins-server"

jk_machine_type_instance = "e2-medium"

jk_zone = "asia-southeast1-b"

jk_internal_ip = "10.0.2.3"


jk_boot_disk_image = "ubuntu-os-cloud/ubuntu-2004-lts"  

jk_boot_disk_size = 50

jk_user_name = "root"

jk_firewall_name = "jenkins-firewall"

jk_allow_rules = [
  {
    protocol = "tcp"
    ports    = ["22"]
  },
  {
    protocol = "tcp"
    ports    = ["8080"]
  },
  {
    protocol = "tcp"
    ports    = ["80"]
  },
  {
    protocol = "tcp"
    ports    = ["443"]
  },
]

jk_source_ranges = ["0.0.0.0/0"]

jk_create_additional_disk = false

################################################################################
# Rancher Instance Module - Variables 
################################################################################

rancher_instance_name = "rancher-server"

rancher_machine_type_instance = "e2-medium"

rancher_zone = "asia-southeast1-b"

rancher_internal_ip = "10.0.2.4"

rancher_boot_disk_image = "ubuntu-os-cloud/ubuntu-2004-lts"  

rancher_boot_disk_size = 50

rancher_user_name = "root"

rancher_firewall_name = "rancher-firewall"

rancher_allow_rules = [
  {
    protocol = "tcp"
    ports    = ["22"]
  },
  {
    protocol = "tcp"
    ports    = ["80"]
  },
    {
    protocol = "tcp"
    ports    = ["443"]
  }
]

rancher_source_ranges = ["0.0.0.0/0"]

rancher_create_additional_disk = true

rancher_disk_type = "pd-standard"

rancher_disk_size = 10

################################################################################
# Nexus Instance Module - Variables 
################################################################################

nexus_instance_name = "nexus-server"

nexus_machine_type_instance = "e2-medium"

nexus_zone = "asia-southeast1-b"

nexus_internal_ip = "10.0.2.5"

nexus_boot_disk_image = "ubuntu-os-cloud/ubuntu-2004-lts"  

nexus_boot_disk_size = 50

nexus_user_name = "root"

nexus_firewall_name = "nexus-firewall"

nexus_allow_rules = [
  {
    protocol = "tcp"
    ports    = ["22"]
  },
  {
    protocol = "tcp"
    ports    = ["8081"]
  },
  {
    protocol = "tcp"
    ports    = ["5000"]
  }
]

nexus_source_ranges = ["0.0.0.0/0"]

nexus_create_additional_disk = true

nexus_disk_type = "pd-standard"

nexus_disk_size = 10


################################################################################
# Vault Instance Module - Variables 
################################################################################

vault_instance_name = "vault-server"

vault_machine_type_instance = "e2-medium"

vault_zone = "asia-southeast1-b"

vault_internal_ip = "10.0.2.6"

vault_boot_disk_image = "ubuntu-os-cloud/ubuntu-2004-lts"  

vault_boot_disk_size = 50

vault_user_name = "root"

vault_firewall_name = "vault-firewall"

vault_allow_rules = [
  {
    protocol = "tcp"
    ports    = ["22"]
  },
  {
    protocol = "tcp"
    ports    = ["8200"]
  },
  {
    protocol = "tcp"
    ports    = ["8201"]
  }
]

vault_source_ranges = ["0.0.0.0/0"]

vault_create_additional_disk = true

vault_disk_type = "pd-standard"

vault_disk_size = 10
