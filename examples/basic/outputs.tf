output "valkey_id" {
  description = "ID of the Valkey database."
  value       = module.valkey.valkey_id
}

output "endpoints" {
  description = "Endpoints of the Valkey database."
  value       = module.valkey.valkey_endpoints
}
