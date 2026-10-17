# Endpoint and credentials come from the OVH_* environment variables.
provider "ovh" {}

module "valkey" {
  source = "../../"

  service_name   = var.service_name
  description    = "Production Valkey cluster - Team Platform"
  valkey_version = "8.1"
  plan           = "business"
  flavor         = "b3-8"
  disk_size      = 100

  deletion_protection = true
  backup_time         = "03:00"
  backup_regions      = ["GRA"]

  advanced_configuration = {
    "maxmemory-policy" = "allkeys-lru"
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
      name       = "app-rw"
      categories = ["+@all"]
      channels   = ["*"]
      commands   = ["+@all"]
      keys       = ["app:*"]
    }
    monitoring = {
      name       = "monitoring"
      categories = ["+@all"]
      channels   = ["*"]
      commands   = ["+@read"]
      keys       = ["*"]
    }
  }
}
