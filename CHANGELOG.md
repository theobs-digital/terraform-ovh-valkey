# Changelog

All notable changes to this module are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this module adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2026-10-18

### Added

- The workflow `Release`: the GitHub release of each tag, with its section of this file as notes

### Changed

- **BREAKING**: variables aligned on the provider's attributes:

  | Before | After |
  |---|---|
  | `valkey_description` | `description` |
  | `valkey_plan` | `plan` |
  | `valkey_flavor` | `flavor` |
  | `valkey_deletion_protection` | `deletion_protection` |
  | `valkey_backup_regions` | `backup_regions` |
  | `valkey_advanced_configuration` | `advanced_configuration` |
  | `valkey_nodes` | `nodes` |
  | `valkey_ip_restrictions` | `ip_restrictions` |
  | `valkey_users`, a list | `valkey_users`, a map keyed by the user's name, without `name` in the object: key each user by its current name to keep it in the state |

- Examples and README: plan `discovery` with one node, `production` with two, as OVHcloud sizes them; the advanced parameter `valkey_maxmemory_policy`, was `maxmemory-policy`

### Removed

- **BREAKING**: `valkey_disk_size` and `valkey_backup_time`. OVHcloud resizes storage only for the engines that use it, and lets the backup time be set only for MongoDB, MySQL and PostgreSQL; Valkey is backed up every 12 hours
- The validations of `plan` and `nodes`: they refused `discovery` and `production`, offered by OVHcloud, and every single-node plan
- The validation of unique user names: the map key is the name

## [1.0.1] - 2026-10-17

### Fixed

- Provider `ovh/ovh` `~> 2.8`, was `>= 1.0, < 2.0`: `ovh_cloud_project_database_valkey_user` exists only from 2.4.0 and the `deletion_protection` attribute of `ovh_cloud_project_database` from 2.8.0, so 1.0.0 validated with no provider release it allowed
- Terraform 1.3 to 1.11: a call without `valkey_disk_size` failed, because `||` evaluated `floor()` on `null` too; Terraform evaluates only one side since 1.12
- Tests: they configured the real provider, which a plan cannot use without credentials, and now run on `mock_provider`; the duplicate user names test gave two different names

### Added

- `LICENSE` (MIT), `.tflint.hcl`, and the workflow `Checks`: the pre-commit hooks and the mock tests on every pull request and push to `main`, and a validation with Terraform 1.3.10 and provider 2.8.0, the bottom of the requirements
- `versions.tf`, `variables.tf`, `outputs.tf` and a README in each example, which configures the provider

### Changed

- README: a Requirements table with the releases the module was checked with, the terraform-docs reference generated from the code instead of written by hand, and the module taken from `github.com/theobs-digital`, not GitLab
- pre-commit-terraform v1.109.2; the terraform-docs reference lists types as HCL blocks

## [1.0.0] - 2026-04-02

### Added

- Valkey database creation on OVHcloud Public Cloud
- Multi-node support (minimum 2 for high availability)
- Optional private network attachment (`network_id`, `subnet_id`)
- Optional IP access restrictions
- Optional backup configuration with time and region
- Optional advanced Valkey configuration (Redis-compatible)
- User management with ACL (categories, channels, commands, keys)
- Deletion protection enabled by default
- Input validations (version format, plan, backup time, disk size, user uniqueness)
- Native Terraform tests (`terraform test`)
- Examples: basic and complete

[Unreleased]: https://github.com/theobs-digital/terraform-ovh-valkey/compare/v2.0.0...main
[2.0.0]: https://github.com/theobs-digital/terraform-ovh-valkey/compare/v1.0.1...v2.0.0
[1.0.1]: https://github.com/theobs-digital/terraform-ovh-valkey/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/theobs-digital/terraform-ovh-valkey/releases/tag/v1.0.0
