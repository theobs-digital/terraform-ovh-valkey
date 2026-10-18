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

run "users_named_by_key" {
  command = plan

  variables {
    create_valkey_users = true
    valkey_users = {
      app = {
        categories = ["+@all"]
        channels   = ["*"]
        commands   = ["+@all"]
        keys       = ["*"]
      }
    }
  }

  assert {
    condition     = ovh_cloud_project_database_valkey_user.user["app"].name == "app"
    error_message = "A user must be named after its key."
  }
}
