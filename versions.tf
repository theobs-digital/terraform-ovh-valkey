terraform {
  required_version = ">= 1.3"

  required_providers {
    ovh = {
      source = "ovh/ovh"
      # 2.8.0: the deletion_protection attribute of ovh_cloud_project_database.
      version = "~> 2.8"
    }
  }
}
