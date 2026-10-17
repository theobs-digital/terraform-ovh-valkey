##############################
# Valkey Database
##############################
resource "ovh_cloud_project_database" "this" {
  service_name           = var.service_name
  description            = var.description
  engine                 = "valkey"
  version                = var.valkey_version
  plan                   = var.plan
  advanced_configuration = var.advanced_configuration
  backup_time            = var.backup_time
  backup_regions         = var.backup_regions
  disk_size              = var.disk_size
  deletion_protection    = var.deletion_protection
  flavor                 = var.flavor

  ##############################
  # Nodes
  ##############################
  dynamic "nodes" {
    for_each = var.nodes
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
    for_each = local.ip_restrictions
    content {
      ip          = ip_restrictions.value.ip
      description = ip_restrictions.value.description
    }
  }
}

##############################
# Valkey Users
##############################
resource "ovh_cloud_project_database_valkey_user" "user" {
  for_each = var.create_valkey_users ? var.valkey_users : {}

  service_name = var.service_name
  cluster_id   = ovh_cloud_project_database.this.id

  categories = each.value.categories
  channels   = each.value.channels
  commands   = each.value.commands
  keys       = each.value.keys
  name       = each.value.name
}
