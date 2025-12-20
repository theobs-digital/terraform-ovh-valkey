  ##############################
  # Valkey Database
  ##############################
resource "ovh_cloud_project_database" "this" {
  service_name           = var.service_name
  description            = var.valkey_description
  engine                 = "valkey"
  version                = var.valkey_version
  plan                   = var.valkey_plan
  advanced_configuration = var.valkey_advanced_configuration
  backup_time            = var.valkey_backup_time
  backup_regions         = var.valkey_backup_regions
  disk_size              = var.valkey_disk_size
  deletion_protection    = var.valkey_deletion_protection
  flavor                 = var.valkey_flavor
  
  ##############################
  # Nodes
  ##############################
  dynamic "nodes" {
    for_each = try(var.valkey_nodes, [])
    content {
      region     = nodes.value.region
      network_id = nodes.value.network_id
      subnet_id  = nodes.value.subnet_id
    }
  }

  ##############################
  # IP Restrictions
  ##############################
  dynamic "ip_restrictions" {
    for_each = try(var.valkey_ip_restrictions, [])
    content {
      ip          = ip_restrictions.value.ip
      description = lookup(ip_restrictions.value, "description", null)
    }
  }
}

