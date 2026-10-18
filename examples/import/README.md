# Import example

Brings an existing Valkey database under the module, with its user `app`:
one `import` block per resource, with the import ID of the provider's
documentation.

| Resource | Import ID |
|---|---|
| `ovh_cloud_project_database.this` | `<service_name>/valkey/<database ID>` |
| `ovh_cloud_project_database_valkey_user.user["<name>"]` | `<service_name>/<database ID>/<user ID>` |

First write each input in `main.tf` as the database has it, its nodes and
users included: a different `region` of the nodes plans a replacement, which
deletes the database once its deletion protection is off. Key each user by
its current name. The module turns deletion protection on by default: on a
database without it, the plan shows that update.

```bash
export OVH_ENDPOINT=ovh-eu OVH_CLIENT_ID=... OVH_CLIENT_SECRET=...
terraform init
terraform plan \
  -var service_name=<Public Cloud project ID> \
  -var cluster_id=<database ID> \
  -var user_id=<user ID>
```

Apply only a plan that imports every object and destroys none: look for
`must be replaced` in it. Once applied, the `import` blocks can go. They need
Terraform 1.6 or later, the first that takes variables in their `id`.
