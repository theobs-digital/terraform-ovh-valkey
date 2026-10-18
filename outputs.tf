output "valkey_id" {
  description = "ID of the Valkey database, for the resources, imports and API calls that act on it."
  value       = ovh_cloud_project_database.this.id
}

output "valkey_engine" {
  description = "Engine of the database, always `valkey`, as the import ID and the OVHcloud API name it."
  value       = ovh_cloud_project_database.this.engine
}

output "valkey_version" {
  description = "Valkey version of the database, for the clients that depend on it."
  value       = ovh_cloud_project_database.this.version
}

output "valkey_endpoints" {
  description = "Endpoints of the database, each with its `component`, `domain`, `path`, `port`, `scheme`, `ssl`, `ssl_mode` and `uri`, to connect the clients."
  value       = ovh_cloud_project_database.this.endpoints
}

output "valkey_nodes" {
  description = "Configuration of the nodes, with their `region`, `network_id` and `subnet_id`, to see where they run."
  value       = ovh_cloud_project_database.this.nodes
}

output "valkey_status" {
  description = "Current status of the database, to check it before connecting clients."
  value       = ovh_cloud_project_database.this.status
}

output "valkey_users" {
  description = "Valkey users created by the module, by key of `valkey_users`, with their `password`, for the clients that log in as them."
  value       = ovh_cloud_project_database_valkey_user.user
  sensitive   = true
}
