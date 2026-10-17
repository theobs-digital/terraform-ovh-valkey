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
  source = "git::https://github.com/theobs-digital/terraform-ovh-valkey.git?ref=v1.0.1"

  service_name   = "your-ovh-project-id"
  valkey_version = "8.1"
  valkey_plan    = "essential"
  valkey_flavor  = "b3-8"

  valkey_nodes = [
    { region = "GRA" },
    { region = "GRA" },
  ]

  create_valkey_users = false
}
```

### With vRack (private network) and users

```hcl
module "valkey" {
  source = "git::https://github.com/theobs-digital/terraform-ovh-valkey.git?ref=v1.0.1"

  service_name       = "your-ovh-project-id"
  valkey_version     = "8.1"
  valkey_plan        = "business"
  valkey_flavor      = "b3-8"
  valkey_description = "Production Valkey cluster"
  valkey_disk_size   = 100

  valkey_nodes = [
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

  valkey_ip_restrictions = [
    { ip = "10.0.0.0/24", description = "Internal network" },
  ]

  valkey_users = [
    {
      name       = "app"
      categories = ["+@all"]
      channels   = ["*"]
      commands   = ["+@all"]
      keys       = ["*"]
    },
  ]
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

#### <a name="input_service_name"></a> [service\_name](#input\_service\_name)

Description: OVH project service name (project ID)

Type: `string`

#### <a name="input_valkey_flavor"></a> [valkey\_flavor](#input\_valkey\_flavor)

Description: Valkey flavor (e.g. b3-8)

Type: `string`

#### <a name="input_valkey_nodes"></a> [valkey\_nodes](#input\_valkey\_nodes)

Description: List of Valkey nodes (minimum 2 for HA)

Type:

```hcl
list(object({
    region     = string
    network_id = optional(string)
    subnet_id  = optional(string)
  }))
```

#### <a name="input_valkey_plan"></a> [valkey\_plan](#input\_valkey\_plan)

Description: Valkey plan (essential, business, enterprise)

Type: `string`

#### <a name="input_valkey_version"></a> [valkey\_version](#input\_valkey\_version)

Description: Valkey engine version (e.g. 7.2, 8.1)

Type: `string`

### Optional Inputs

The following input variables are optional (have default values):

#### <a name="input_create_valkey_users"></a> [create\_valkey\_users](#input\_create\_valkey\_users)

Description: Enable or disable Valkey user creation

Type: `bool`

Default: `true`

#### <a name="input_valkey_advanced_configuration"></a> [valkey\_advanced\_configuration](#input\_valkey\_advanced\_configuration)

Description: Advanced Valkey configuration (Redis-compatible key/value pairs)

Type: `map(string)`

Default: `null`

#### <a name="input_valkey_backup_regions"></a> [valkey\_backup\_regions](#input\_valkey\_backup\_regions)

Description: List of regions where backups are stored

Type: `list(string)`

Default: `null`

#### <a name="input_valkey_backup_time"></a> [valkey\_backup\_time](#input\_valkey\_backup\_time)

Description: Backup time in HH:MM format (UTC)

Type: `string`

Default: `null`

#### <a name="input_valkey_deletion_protection"></a> [valkey\_deletion\_protection](#input\_valkey\_deletion\_protection)

Description: Enable deletion protection

Type: `bool`

Default: `true`

#### <a name="input_valkey_description"></a> [valkey\_description](#input\_valkey\_description)

Description: Description of the Valkey database

Type: `string`

Default: `null`

#### <a name="input_valkey_disk_size"></a> [valkey\_disk\_size](#input\_valkey\_disk\_size)

Description: Disk size in GB (optional, OVH default if null)

Type: `number`

Default: `null`

#### <a name="input_valkey_ip_restrictions"></a> [valkey\_ip\_restrictions](#input\_valkey\_ip\_restrictions)

Description: List of IP restrictions for Valkey access

Type:

```hcl
list(object({
    ip          = string
    description = optional(string)
  }))
```

Default: `null`

#### <a name="input_valkey_users"></a> [valkey\_users](#input\_valkey\_users)

Description: List of Valkey users with ACL configuration

Type:

```hcl
list(object({
    name       = string
    categories = list(string)
    channels   = list(string)
    commands   = list(string)
    keys       = list(string)
  }))
```

Default: `[]`

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
| `valkey_plan` | Must be `essential`, `business`, or `enterprise` |
| `valkey_nodes` | Minimum 2 nodes |
| `valkey_disk_size` | Positive integer when set |
| `valkey_backup_time` | `HH:MM` format when set |
| `valkey_users` | Names must be unique |

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
