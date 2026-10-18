# terraform-ovh-valkey

> Terraform module to create and manage a **Valkey** (Redis-compatible) database on OVHcloud Public Cloud.

## Design decisions

- OVHcloud-focused and intentionally opinionated
- Valkey-only to avoid unsafe generic database abstractions
- Network creation is out of scope — must be handled by a dedicated network module
- Designed to be orchestrated by higher-level tools such as Ansible

## Usage

### Minimal (public network)

```hcl
module "valkey" {
  source = "git::https://github.com/theobs-digital/terraform-ovh-valkey.git?ref=v2.0.0"

  service_name   = "your-ovh-project-id"
  valkey_version = "8.1"
  plan           = "discovery"
  flavor         = "b3-8"

  nodes = [
    { region = "GRA" },
  ]

  create_valkey_users = false
}
```

### With vRack (private network) and users

```hcl
module "valkey" {
  source = "git::https://github.com/theobs-digital/terraform-ovh-valkey.git?ref=v2.0.0"

  service_name   = "your-ovh-project-id"
  valkey_version = "8.1"
  plan           = "production"
  flavor         = "b3-8"
  description    = "Production Valkey cluster"

  nodes = [
    {
      region     = "GRA"
      network_id = "pn-xxxxxx"
      subnet_id  = "subnet-yyyyyy"
    },
    {
      region     = "GRA"
      network_id = "pn-xxxxxx"
      subnet_id  = "subnet-yyyyyy"
    },
  ]

  ip_restrictions = [
    { ip = "10.0.0.0/24", description = "Internal network" },
  ]

  valkey_users = {
    app = {
      categories = ["+@all"]
      channels   = ["*"]
      commands   = ["+@all"]
      keys       = ["*"]
    }
  }
}
```

See [examples/basic](examples/basic/) and [examples/complete](examples/complete/) for more.

## Requirements

| | Version | Checked with |
|---|---|---|
| Terraform | `>= 1.3` | 1.3.10 and 1.16.5 |
| Provider [`ovh/ovh`](https://registry.terraform.io/providers/ovh/ovh/latest) | `~> 2.8` | 2.8.0 and 2.22.0 |

## Reference

<!-- BEGIN_TF_DOCS -->
### Resources

The following resources are used by this module:

- [ovh_cloud_project_database.this](https://registry.terraform.io/providers/ovh/ovh/latest/docs/resources/cloud_project_database) (resource)
- [ovh_cloud_project_database_valkey_user.user](https://registry.terraform.io/providers/ovh/ovh/latest/docs/resources/cloud_project_database_valkey_user) (resource)

### Required Inputs

The following input variables are required:

#### <a name="input_flavor"></a> [flavor](#input\_flavor)

Description: Valkey flavor, such as `b3-8`.

Type: `string`

#### <a name="input_nodes"></a> [nodes](#input\_nodes)

Description: Valkey nodes, as many as the plan requires, such as 1 for `discovery` and 2 for `production`.

Type:

```hcl
list(object({
    region     = string
    network_id = optional(string)
    subnet_id  = optional(string)
  }))
```

#### <a name="input_plan"></a> [plan](#input\_plan)

Description: Valkey plan, such as `discovery` or `production`.

Type: `string`

#### <a name="input_service_name"></a> [service\_name](#input\_service\_name)

Description: OVH project service name (project ID).

Type: `string`

#### <a name="input_valkey_version"></a> [valkey\_version](#input\_valkey\_version)

Description: Valkey engine version, such as `8.1` or `9.1`.

Type: `string`

### Optional Inputs

The following input variables are optional (have default values):

#### <a name="input_advanced_configuration"></a> [advanced\_configuration](#input\_advanced\_configuration)

Description: Advanced Valkey parameters of OVHcloud, such as `valkey_maxmemory_policy`.

Type: `map(string)`

Default: `null`

#### <a name="input_backup_regions"></a> [backup\_regions](#input\_backup\_regions)

Description: List of regions where backups are stored.

Type: `list(string)`

Default: `null`

#### <a name="input_create_valkey_users"></a> [create\_valkey\_users](#input\_create\_valkey\_users)

Description: Whether the module creates Valkey users.

Type: `bool`

Default: `true`

#### <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection)

Description: Whether deletion protection is enabled.

Type: `bool`

Default: `true`

#### <a name="input_description"></a> [description](#input\_description)

Description: Description of the Valkey database.

Type: `string`

Default: `null`

#### <a name="input_ip_restrictions"></a> [ip\_restrictions](#input\_ip\_restrictions)

Description: List of IP restrictions for Valkey access.

Type:

```hcl
list(object({
    ip          = string
    description = optional(string)
  }))
```

Default: `null`

#### <a name="input_valkey_users"></a> [valkey\_users](#input\_valkey\_users)

Description: Valkey users with their ACL, by name: the key is the user's `name`, so renaming a key replaces the user.

Type:

```hcl
map(object({
    categories = list(string)
    channels   = list(string)
    commands   = list(string)
    keys       = list(string)
  }))
```

Default: `{}`

### Outputs

The following outputs are exported:

#### <a name="output_valkey_endpoints"></a> [valkey\_endpoints](#output\_valkey\_endpoints)

Description: Valkey endpoints

#### <a name="output_valkey_engine"></a> [valkey\_engine](#output\_valkey\_engine)

Description: Database engine

#### <a name="output_valkey_id"></a> [valkey\_id](#output\_valkey\_id)

Description: Valkey database ID

#### <a name="output_valkey_nodes"></a> [valkey\_nodes](#output\_valkey\_nodes)

Description: Valkey nodes configuration

#### <a name="output_valkey_status"></a> [valkey\_status](#output\_valkey\_status)

Description: Current Valkey database status

#### <a name="output_valkey_users"></a> [valkey\_users](#output\_valkey\_users)

Description: Created Valkey users

#### <a name="output_valkey_version"></a> [valkey\_version](#output\_valkey\_version)

Description: Valkey version
<!-- END_TF_DOCS -->

## Validations

The module enforces the following rules at `terraform plan` time:

| Variable | Rule |
|----------|------|
| `valkey_version` | Must match format `X.Y` |

## Tests

Run the native Terraform tests:

```bash
terraform test
```

## Contributing

This module uses [pre-commit](https://pre-commit.com/) hooks for code quality:

```bash
pre-commit install
pre-commit run -a
```

Documentation is auto-generated by [terraform-docs](https://terraform-docs.io/) between the `BEGIN_TF_DOCS` / `END_TF_DOCS` markers.

## License

See [LICENSE](LICENSE) for details.
