resource "opennebula_virtual_machine" "staging_vm" {
  name        = "makerspace-staging"
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
      hostname = "makerspace-staging"
      github_users = var.github_users
    })
  }
}
