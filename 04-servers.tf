resource "linode_instance" "terraform-web" {
  image = "linode/almalinux9"
#   image = "linode/rocky9"
  label = "asiwko-vm-01"
  # group = "Terraform"
  region          = "us-iad"
  type            = "g6-nanode-1"
  authorized_keys = [file("/container_shared/ansible/ansible_rsa.pub")]
  root_pass       = file("/container_shared/ansible/linode-root-pw.txt")
}
