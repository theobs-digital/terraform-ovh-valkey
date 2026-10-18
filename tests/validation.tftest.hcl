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

run "reject_bad_version_format" {
  command = plan

  variables {
    valkey_version = "latest"
  }

  expect_failures = [
    var.valkey_version,
  ]
}
