# Endpoint and credentials come from the OVH_* environment variables.
provider "ovh" {}

module "valkey" {
  source = "../../"

  service_name   = var.service_name
  description    = "Production Valkey cluster - Team Platform"
  valkey_version = "8.1"
  plan           = "production"
  flavor         = "b3-8"

  deletion_protection = true
  backup_regions      = ["GRA"]

  advanced_configuration = {
    valkey_maxmemory_policy = "allkeys-lru"
  }

  nodes = [
    {
      region     = "GRA"
      network_id = var.network_id
      subnet_id  = var.subnet_id
    },
    {
      region     = "GRA"
      network_id = var.network_id
      subnet_id  = var.subnet_id
    },
  ]

  ip_restrictions = [
    { ip = "10.0.0.0/8", description = "Private RFC1918" },
  ]

  valkey_users = {
    app-rw = {
      categories = ["+@all"]
      channels   = ["*"]
      commands   = ["+@all"]
      keys       = ["app:*"]
    }
    monitoring = {
      categories = ["+@all"]
      channels   = ["*"]
      commands   = ["+@read"]
      keys       = ["*"]
    }
  }
}
