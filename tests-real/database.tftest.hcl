# Real API, not a mock: a Valkey database tf-test-ci-valkey on plan discovery,
# with one b3-8 node in GRA and the user tf-test-ci, created then destroyed.
# Deletion protection stays off, or the destroy would fail.
#
#   export OVH_ENDPOINT=ovh-eu OVH_APPLICATION_KEY=... OVH_APPLICATION_SECRET=... OVH_CONSUMER_KEY=...
#   export TF_VAR_service_name=... TF_VAR_valkey_version=8.1
#   terraform test -test-directory=tests-real
provider "ovh" {}

variables {
  description         = "tf-test-ci-valkey"
  plan                = "discovery"
  flavor              = "b3-8"
  deletion_protection = false

  nodes = [
    { region = "GRA" },
  ]

  valkey_users = {
    tf-test-ci = {
      categories = ["+@all"]
      channels   = ["*"]
      commands   = ["+@all"]
      keys       = ["*"]
    }
  }
}

run "create" {
  assert {
    condition     = length(output.valkey_endpoints) > 0
    error_message = "The database must have its endpoints."
  }

  assert {
    condition     = ovh_cloud_project_database_valkey_user.user["tf-test-ci"].name == "tf-test-ci"
    error_message = "The user must be created."
  }
}

# A plan that replaces an object leaves its ID unknown, which fails the run:
# this catches a replacement, not an update in place.
run "no_replacement" {
  command = plan

  assert {
    condition     = ovh_cloud_project_database.this.id == run.create.valkey_id
    error_message = "A second plan must keep the database."
  }

  assert {
    condition     = ovh_cloud_project_database_valkey_user.user["tf-test-ci"].id != null
    error_message = "A second plan must keep the user."
  }
}
