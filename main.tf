resource "openstack_compute_instance_v2" "kubernetes_master_final_instance" {
image_name = "ubuntu-20.04"
flavor_name = "l2.c2r4.100"
key_pair = "project2-master"
name = "kubernetes-master-final"
network {
name = "public"
}
provisioner "file" {
source = "scripts/master-install-kubernetes1.sh"
destination = "master-install-kubernetes1.sh"
}

provisioner "file" {
source = "scripts/master-install-kubernetes2.sh"
destination = "master-install-kubernetes2.sh"
}

provisioner "file" {
source = "scripts/master-install-kubernetes3.sh"
destination = "master-install-kubernetes3.sh"
}


provisioner "file" {
source = "application/wordpress.yaml"
destination = "wordpress.yaml"
}


provisioner "file" {
source = "application/mysql.yaml"
destination = "mysql.yaml"
}

provisioner "file" {
source = "application/wordpress-pvc.yaml"
destination = "wordpress-pvc.yaml"
}
provisioner "file" {
source = "application/wordpress-pv.yaml"
destination = "wordpress-pv.yaml"
}
provisioner "file" {
source = "application/mysql-pvc.yaml"
destination = "mysql-pvc.yaml"
}
provisioner "file" {
source = "application/mysql-pv.yaml"
destination = "mysql-pv.yaml"
}
provisioner "file" {
source = "application/nginx.yaml"
destination = "nginx.yaml"
}

provisioner "file" {
source = "application/kustomization.yaml"
destination = "kustomization.yaml"
}
connection {
type = "ssh"
user = "ubuntu"
private_key = "${file("~/.ssh/id_rsa")}"
host = openstack_compute_instance_v2.kubernetes_master_final_instance.access_ip_v4
}
provisioner "remote-exec" {
inline = [
"sleep 20",
"sudo apt update",
"wget https://apt.puppet.com/puppet7-release-focal.deb",
"sudo dpkg -i puppet7-release-focal.deb",
"sudo apt-get update",
"sudo apt-get install puppet-agent -y",
"sudo sed -i '2i${var.master_ip} master.project master' /etc/hosts",
"sudo sed -i -e '$a[main]' /etc/puppetlabs/puppet/puppet.conf",
"sudo sed -i -e '$acertname = kubernetesmasterserver.project' /etc/puppetlabs/puppet/puppet.conf",
"sudo sed -i -e '$aserver = master.project' /etc/puppetlabs/puppet/puppet.conf",
"sudo sed -i -e '$aruninterval = 3m' /etc/puppetlabs/puppet/puppet.conf",
"sudo systemctl start puppet",
"sudo apt -y full-upgrade",
"sudo shutdown -r +0"
]
}
}

resource "openstack_compute_instance_v2" "kubernetes_final_node_instance" {
image_name = "ubuntu-20.04"
flavor_name = "l2.c2r4.100"
key_pair = "project2-master"
name = "kubernetes-final-node"
network {
name = "default"
}
provisioner "file" {
source = "scripts/node-install-kubernetes1.sh"
destination = "node-install-kubernetes1.sh"
}

provisioner "file" {
source = "scripts/node-install-kubernetes2.sh"
destination = "node-install-kubernetes2.sh"
}

connection {
type = "ssh"
user = "ubuntu"
private_key = "${file("~/.ssh/id_rsa")}"
host = self.access_ip_v4
}
provisioner "remote-exec" {
inline = [
"sleep 20",
"sudo apt update",
"sudo apt -y full-upgrade",
"wget https://apt.puppet.com/puppet7-release-focal.deb",
"sudo dpkg -i puppet7-release-focal.deb",
"sudo apt-get update",
"sudo apt-get install puppet-agent -y",
"sudo sed -i '2i${var.master_ip} master.project master' /etc/hosts",
"sudo sed -i -e '$a[main]' /etc/puppetlabs/puppet/puppet.conf",
"sudo sed -i -e '$acertname = kubernetesnode0server.project' /etc/puppetlabs/puppet/puppet.conf",
"sudo sed -i -e '$aserver = master.project' /etc/puppetlabs/puppet/puppet.conf",
"sudo sed -i -e '$aruninterval = 3m' /etc/puppetlabs/puppet/puppet.conf",
"sudo systemctl start puppet",
"sudo shutdown -r +0"
]
}
}
