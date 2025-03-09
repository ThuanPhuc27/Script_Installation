jenkins: 
	ansible-playbook -i inventories/hosts.ini playbooks/jenkins-server.yml
rancher:
	ansible-playbook -i inventories/hosts.ini playbooks/rancher-server.yml
lb:
	ansible-playbook -i inventories/hosts.ini playbooks/load-balancing.yml
nexus:
	ansible-playbook -i inventories/hosts.ini playbooks/nexus-server.yml
vault:
	ansible-playbook -i inventories/hosts.ini playbooks/vault-server.yml