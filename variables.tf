variable "service_name" {
  description = "OVH project service name (project ID)."
  type        = string
}

variable "description" {
  description = "Description of the Valkey database."
  type        = string
  default     = null
}

variable "valkey_version" {
  description = "Valkey engine version, such as `7.2` or `8.1`."
  type        = string

  validation {
    condition     = can(regex("^\\d+\\.\\d+$", var.valkey_version))
    error_message = "valkey_version must follow the format 'X.Y' (e.g. 7.2, 8.1)."
  }
}

variable "plan" {
  description = "Valkey plan: `essential`, `business` or `enterprise`."
  type        = string

  validation {
    condition     = contains(["essential", "business", "enterprise"], var.plan)
    error_message = "plan must be one of: essential, business, enterprise."
  }
}

variable "flavor" {
  description = "Valkey flavor, such as `b3-8`."
  type        = string
}

variable "disk_size" {
  description = "Disk size in GB (optional, OVH default if `null`)."
  type        = number
  default     = null

  validation {
    condition = (
      var.disk_size == null ? true :
      var.disk_size == floor(var.disk_size) && var.disk_size > 0
    )
    error_message = "disk_size must be a positive integer when set."
  }
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled."
  type        = bool
  default     = true
}

variable "backup_time" {
  description = "Backup time in `HH:MM` format (UTC)."
  type        = string
  default     = null

  validation {
    condition     = var.backup_time == null || can(regex("^([01]\\d|2[0-3]):[0-5]\\d$", var.backup_time))
    error_message = "backup_time must follow HH:MM format (e.g. 03:00)."
  }
}

variable "backup_regions" {
  description = "List of regions where backups are stored."
  type        = list(string)
  default     = null
}

variable "advanced_configuration" {
  description = "Advanced Valkey configuration (Redis-compatible key/value pairs)."
  type        = map(string)
  default     = null
}

variable "nodes" {
  description = "List of Valkey nodes (minimum 2 for HA)."
  type = list(object({
    region     = string
    network_id = optional(string)
    subnet_id  = optional(string)
  }))

  validation {
    condition     = length(var.nodes) >= 2
    error_message = "At least two Valkey nodes must be defined for high availability."
  }
}

variable "ip_restrictions" {
  description = "List of IP restrictions for Valkey access."
  type = list(object({
    ip          = string
    description = optional(string)
  }))
  default = null
}

variable "create_valkey_users" {
  description = "Whether the module creates Valkey users."
  type        = bool
  default     = true
}

variable "valkey_users" {
  description = "Valkey users with ACL configuration, by a key of your choice. The key only names the user in the state: keep it stable, since renaming a key replaces the user."
  type = map(object({
    name       = string
    categories = list(string)
    channels   = list(string)
    commands   = list(string)
    keys       = list(string)
  }))
  default = {}

  validation {
    condition     = length(var.valkey_users) == length(distinct([for u in var.valkey_users : u.name]))
    error_message = "User names must be unique."
  }
}
