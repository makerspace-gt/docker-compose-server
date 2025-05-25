provider "sops" {}

provider "opennebula" {
  endpoint = local.opennebula_provider
  username = local.opennebula_username
  password = local.opennebula_password
}
