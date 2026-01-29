resource "linode_instance" "terraform-web" {
  image = "linode/almalinux9"
  # image = "linode/rocky9"
  label = "asiwko-vm-01"
  # iad was full
  # region          = "us-iad"
  region          = "us-southeast"
  type            = "g6-nanode-1"
  authorized_keys = [trimspace(file("/container_shared/ansible/ansible_rsa.pub"))]
  root_pass       = trimspace(file("/container_shared/ansible/linode-root-pw.txt"))
}
