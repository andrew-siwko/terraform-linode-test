resource "linode_instance" "terraform-web" {
  image = "linode/ubuntu24.04"
  label = "Terraform-Web-Example"
  # group = "Terraform"
  region          = "us-iad"
  type            = "g6-nanode-1"
  authorized_keys = [file("/container_shared/ansible/ansible_rsa.pub")]
#   root_pass       = "YOUR_ROOT_PASSWORD"
}
