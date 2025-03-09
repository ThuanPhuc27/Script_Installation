curl https://cdn.teleport.dev/install.sh | bash -s 17.0.5
sudo certbot certonly --standalone -d teleport.lptdevops.website
teleport configure -o file --acme --acme-email=thuanlephuc152@gmail.com --cluster-name=teleport.lptdevops.website
systemctl enable teleport
systemctl start teleport
tctl users add admin --roles=editor,access --logins=root