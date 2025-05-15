resource "opennebula_virtual_machine" "staging_vm" {
  name = "makerspace-staging"

# Replace with the actual template ID
  template_id = "PLACEHOLDER_TEMPLATE_ID"  
  memory      = 16384
  vcpu        = 4
  disk {
    size = 100
  }
  nic {
    network = "default"
    model   = "virtio"
  }
  context = {
    cloud_init = file("cloud-init.yaml")
  }

  public_ip = true
}

