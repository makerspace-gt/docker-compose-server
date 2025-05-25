terraform  {
  required_providers {
    opennebula = {
      source = "OpenNebula/opennebula"
      version = "1.4.1"
    }
    sops = {
      source = "carlpett/sops"
      version = "1.2.0"
    }
  }
}
