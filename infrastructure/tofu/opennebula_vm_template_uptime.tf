resource "opennebula_virtual_machine" "uptime_vm" {
  name = "makerspace-uptime"
  template_id = "PLACEHOLDER_TEMPLATE_ID"  # Replace with the actual template ID for the smaller VM
  memory      = 2048
  vcpu        = 1
  disk {
    size = 16
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
