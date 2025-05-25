resource "opennebula_virtual_machine" "uptime_vm" {
  name        = "makerspace-uptime"
  template_id = var.template_id
  memory      = 2048
  vcpu        = 2

  disk {
    size = 16
  }

  nic {
    model   = "virtio"
  }

  context = {
    cloud_init = templatefile("cloud-init.yaml", {
      hostname = "makerspace-uptime"
      github_users = var.github_users
    })
  }
}
