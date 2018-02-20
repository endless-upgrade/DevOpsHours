provider "google" {
  credentials = "${file("terraform-admin.json")}"
  project     = "endless-upgrade"
  region      = "us-east1-b"
}

resource "google_compute_instance" "worker" {
 project = "endless-upgrade"
 zone = "us-east1-b"
 count = "${var.server_count}"
 name = "gcp-cluster-node-${count.index}"
 machine_type = "n1-standard-2"
 tags = ["jenkins", "monitoring", "http", "https"]
 
 boot_disk {
   initialize_params {
     image = "centos-7-v20171213"
     size = "30"
   }
 }
 
 ...

 provisioner "local-exec" {
  command = "sleep 90;
   ansible-playbook -i '${google_compute_instance.worker.name},'
   --private-key=~/.ssh/ansible_rsa /opt/ansible/cluster-nodes.yml
   -e 'ansible_ssh_user=dario_pasquali93' -e 'host_key_checking=False'"
 }
}

 ...

output "worker" {
 value = "${google_compute_instance.worker.self_link}"
}


