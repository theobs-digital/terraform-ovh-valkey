# OVHcloud Valkey Terraform Module

🧠 Design decisions

This module is OVHcloud-focused and intentionally opinionated

The module is Valkey-only (Redis-compatible) to avoid unsafe generic database abstractions

Network creation is explicitly out of scope and must be handled by a dedicated network module

The module is designed to be orchestrated by higher-level tools such as Ansible

---

## 🇬🇧 Description

Terraform module to create and manage a **Valkey (Redis-compatible) database** on OVHcloud Public Cloud.

This module focuses exclusively on Valkey use cases and enforces clear boundaries to prevent misconfiguration, while remaining simple, predictable, and production-ready.

---

## 🇬🇧 Features

- Creation of a Valkey database on OVHcloud Public Cloud  
- Support for two or multiple Valkey nodes (HA-ready)  
- Attachment of Valkey nodes to an existing private network and subnet  
- Optional IP access restrictions  
- Optional backup configuration  
- Optional advanced Valkey (Redis-compatible) configuration  
- Safe usage of `dynamic` blocks for repeatable resources  
- Designed to be orchestrated by Ansible  

---

## 🇬🇧 Requirements

- Terraform >= 1.14
- OVHcloud Terraform Provider  
- An existing OVHcloud Public Cloud project  
- An existing private network and subnet  

---

## 🇬🇧 Input Variables

### Required variables

| Name | Description |
|----|------------|
| `service_name` | OVHcloud Public Cloud project ID |
| `valkey_version` | Valkey version |
| `valkey_plan` | Valkey plan (e.g. production) |
| `valkey_flavor` | Valkey flavor (e.g. b3-8) |
| `valkey_disk_size` | Disk size in GB |
| `valkey_nodes` | List of Valkey nodes |

---

### Optional variables

| Name | Type | Default | Description |
|----|----|----|----|
| `valkey_description` | `string` | `null` | Database description |
| `valkey_backup_time` | `string` | `null` | Backup time (HH:MM) |
| `valkey_backup_regions` | `list(string)` | `null` | Backup regions |
| `valkey_advanced_configuration` | `map(string)` | `null` | Advanced Valkey configuration |
| `valkey_deletion_protection` | `bool` | `true` | Enable deletion protection |
| `valkey_ip_restrictions` | `list(object)` | `null` | IP access restrictions |

---

### Valkey Node Object

| Field | Type | Description |
|----|----|------------|
| `region` | `string` | OVHcloud region |
| `network_id` | `string` | Private network ID |
| `subnet_id` | `string` | Subnet ID |

---

### IP Restriction Object

| Field | Type | Description |
|----|----|------------|
| `ip` | `string` | Allowed IP or CIDR |
| `description` | `string` | Optional description |

---

## 🇬🇧 Important Validations

This module enforces the following rules:

1. At least one Valkey node must be defined  
2. Node definitions must include region, network ID, and subnet ID  
3. Disk size must be a positive integer  
4. Unsupported or missing configurations are blocked at `terraform plan` time  

These validations ensure predictable and safe deployments.

---

## 🇬🇧 Examples of usage

### Single-node Valkey deployment

```hcl
module "valkey" {
  source = "./modules/ovh-valkey"

  service_name               = var.service_name
  valkey_description         = "Production Valkey cluster"
  valkey_version             = "8.1"
  valkey_plan                = "production"
  valkey_flavor              = "b3-8"
  valkey_disk_size           = 100
  valkey_deletion_protection = true

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
    }
  ]

  valkey_ip_restrictions = [
    {
      ip          = "10.0.0.0/24"
      description = "Internal network"
    }
  ]
}
