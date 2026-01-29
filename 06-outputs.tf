output "machine_keys" {
  value = keys(linode_instance.asiwko-vm-01)
}

output "machine_info" {
  value = {
    id     = linode_instance.asiwko-vm-01.id
    label  = linode_instance.asiwko-vm-01.label
    ip     = linode_instance.asiwko-vm-01.ip_address
    region = linode_instance.asiwko-vm-01.region
  }
}