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
  description = "Valkey engine version, such as `8.1` or `9.1`."
  type        = string

  # Provider 2.22 takes any string, while OVHcloud lists Valkey versions as major.minor, such as 8.1.
  validation {
    condition     = can(regex("^\\d+\\.\\d+$", var.valkey_version))
    error_message = "valkey_version must follow the format 'X.Y' (e.g. 8.1)."
  }
}

variable "plan" {
  description = "Valkey plan, such as `discovery` or `production`."
  type        = string
}

variable "flavor" {
  description = "Valkey flavor, such as `b3-8`."
  type        = string
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled."
  type        = bool
  # Protected unless asked: provider 2.22 leaves the database unprotected when unset.
  default = true
}

variable "backup_regions" {
  description = "List of regions where backups are stored."
  type        = list(string)
  default     = null
}

variable "advanced_configuration" {
  description = "Advanced Valkey parameters of OVHcloud, such as `valkey_maxmemory_policy`."
  type        = map(string)
  default     = null
}

variable "nodes" {
  description = "Valkey nodes, as many as the plan requires, such as 1 for `discovery` and 2 for `production`."
  type = list(object({
    region     = string
    network_id = optional(string)
    subnet_id  = optional(string)
  }))
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
  description = "Valkey users with their ACL, by name: the key is the user's `name`, so renaming a key replaces the user."
  type = map(object({
    categories = list(string)
    channels   = list(string)
    commands   = list(string)
    keys       = list(string)
  }))
  default = {}
}
