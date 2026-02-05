output "machine_info-01" {
  value = {
    id     = linode_instance.asiwko-vm-01.id
    label  = linode_instance.asiwko-vm-01.label
    ipv4   = linode_instance.asiwko-vm-01.ipv4
    ipv6   = linode_instance.asiwko-vm-01.ipv6
    region = linode_instance.asiwko-vm-01.region
  }
}
