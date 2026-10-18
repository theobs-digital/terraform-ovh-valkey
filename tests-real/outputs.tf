output "valkey_id" {
  description = "ID of the test database, to find it if a run leaves it behind."
  value       = module.valkey.valkey_id
}
