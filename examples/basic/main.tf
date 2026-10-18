# Endpoint and credentials come from the OVH_* environment variables.
provider "ovh" {}

module "valkey" {
  source = "../../"

  service_name   = var.service_name
  valkey_version = "8.1"
  plan           = "discovery"
  flavor         = "b3-8"

  nodes = [
    { region = "GRA" },
  ]

  create_valkey_users = false
}
