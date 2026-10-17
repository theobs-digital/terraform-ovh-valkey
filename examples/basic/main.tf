# Endpoint and credentials come from the OVH_* environment variables.
provider "ovh" {}

module "valkey" {
  source = "../../"

  service_name   = var.service_name
  valkey_version = "8.1"
  valkey_plan    = "essential"
  valkey_flavor  = "b3-8"

  valkey_nodes = [
    { region = "GRA" },
    { region = "GRA" },
  ]

  create_valkey_users = false
}
