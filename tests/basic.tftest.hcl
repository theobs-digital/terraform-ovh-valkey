mock_provider "ovh" {}

variables {
  service_name   = "test-project-id"
  valkey_version = "8.1"
  plan           = "discovery"
  flavor         = "b3-8"
  nodes = [
    { region = "GRA" },
  ]
  create_valkey_users = false
}

run "plan_basic" {
  command = plan

  assert {
    condition     = ovh_cloud_project_database.this.engine == "valkey"
    error_message = "Engine must be valkey."
  }

  assert {
    condition     = ovh_cloud_project_database.this.deletion_protection == true
    error_message = "Deletion protection must be enabled by default."
  }
}
