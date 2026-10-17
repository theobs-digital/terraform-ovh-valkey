# Complete example

Creates a Valkey 8.1 database on plan `business`, with two nodes in an
existing private network (vRack), a 100 GB disk, daily backups at 03:00 UTC,
an advanced setting, an IP restriction, and two users with their ACL.

```bash
export OVH_ENDPOINT=ovh-eu OVH_CLIENT_ID=... OVH_CLIENT_SECRET=...
terraform init
terraform apply \
  -var service_name=<Public Cloud project ID> \
  -var network_id=<private network ID> \
  -var subnet_id=<subnet ID>
```

Deletion protection is on: set `valkey_deletion_protection = false` and apply
before `terraform destroy`.
