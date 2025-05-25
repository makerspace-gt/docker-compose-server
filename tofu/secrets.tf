data "sops_file" "secrets" {
  source_file = "tfsecrets.yaml"
}

locals {
  opennebula_provider = data.sops_file.secrets.data["opennebula.provider"]
  opennebula_username = data.sops_file.secrets.data["opennebula.username"]
  opennebula_password = data.sops_file.secrets.data["opennebula.password"]
}
