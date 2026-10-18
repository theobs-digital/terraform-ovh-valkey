# Endpoint and credentials come from the OVH_* environment variables.
provider "ovh" {}

# The database as it is: an input that differs plans an update, or a
# replacement for the attributes that recreate the resource.
module "valkey" {
  source = "../../"

  service_name   = var.service_name
  valkey_version = "8.1"
  plan           = "discovery"
  flavor         = "b3-8"

  nodes = [
    { region = "GRA" },
  ]

  # The key is the user's current name.
  valkey_users = {
    app = {
      categories = ["+@all"]
      channels   = ["*"]
      commands   = ["+@all"]
      keys       = ["*"]
    }
  }
}

import {
  to = module.valkey.ovh_cloud_project_database.this
  id = "${var.service_name}/valkey/${var.cluster_id}"
}

import {
  to = module.valkey.ovh_cloud_project_database_valkey_user.user["app"]
  id = "${var.service_name}/${var.cluster_id}/${var.user_id}"
}
