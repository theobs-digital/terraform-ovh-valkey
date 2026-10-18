# Real API, not a mock: apply this configuration, plan it again, which must
# show no change, and destroy it. A Valkey database tf-test-ci-valkey on plan
# discovery, with one b3-8 node in GRA and the user tf-test-ci. Deletion
# protection stays off, or the destroy would fail.
#
#   export OVH_ENDPOINT=ovh-eu OVH_APPLICATION_KEY=... OVH_APPLICATION_SECRET=... OVH_CONSUMER_KEY=...
#   export TF_VAR_service_name=... TF_VAR_valkey_version=8.1
#   terraform init
#   terraform apply
#   terraform plan -detailed-exitcode
#   terraform destroy
provider "ovh" {}

module "valkey" {
  source = "../"

  service_name        = var.service_name
  description         = "tf-test-ci-valkey"
  valkey_version      = var.valkey_version
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
