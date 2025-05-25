resource "opennebula_virtual_machine" "production_vm" {
  name        = "makerspace-production"
  template_id = var.template_id
  memory      = 16384
  vcpu        = 4

  disk {
    size = 100
  }

  nic {
    model   = "virtio"
  }

  context = {
    cloud_init = templatefile("cloud-init.yaml", {
      hostname = "makerspace-production"
      github_users = var.github_users
    })
  }
}

