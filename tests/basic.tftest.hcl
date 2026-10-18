mock_provider "ovh" {}

variables {
  service_name   = "test-project-id"
  valkey_version = "8.1"
  plan           = "essential"
  flavor         = "b3-8"
  nodes = [
    { region = "GRA" },
    { region = "GRA" },
  ]
  create_valkey_users = false
}

##############################
# Valid plan
##############################

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

##############################
# Validation: reject single node
##############################

run "reject_single_node" {
  command = plan

  variables {
    nodes = [{ region = "GRA" }]
  }

  expect_failures = [
    var.nodes,
  ]
}

##############################
# Validation: reject bad version format
##############################

run "reject_bad_version_format" {
  command = plan

  variables {
    valkey_version = "latest"
  }

  expect_failures = [
    var.valkey_version,
  ]
}

##############################
# Validation: reject invalid plan name
##############################

run "reject_invalid_plan" {
  command = plan

  variables {
    plan = "free-tier"
  }

  expect_failures = [
    var.plan,
  ]
}

##############################
# Validation: reject bad backup time
##############################

run "reject_bad_backup_time" {
  command = plan

  variables {
    backup_time = "25:00"
  }

  expect_failures = [
    var.backup_time,
  ]
}

##############################
# Validation: reject duplicate user names
##############################

run "reject_duplicate_users" {
  command = plan

  variables {
    create_valkey_users = true
    valkey_users = {
      app-all = {
        name       = "app"
        categories = ["+@all"]
        channels   = ["*"]
        commands   = ["+@all"]
        keys       = ["*"]
      }
      app-read = {
        name       = "app"
        categories = ["+@all"]
        channels   = ["*"]
        commands   = ["+@read"]
        keys       = ["*"]
      }
    }
  }

  expect_failures = [
    var.valkey_users,
  ]
}

##############################
# Validation: reject negative disk size
##############################

run "reject_negative_disk_size" {
  command = plan

  variables {
    disk_size = -10
  }

  expect_failures = [
    var.disk_size,
  ]
}
