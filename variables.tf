############################################
# Global
############################################

variable "service_name" {
  description = "OVH project service name (project ID)"
  type        = string
}

############################################
# Valkey / Redis configuration
############################################

variable "valkey_description" {
  description = "Description of the Valkey database"
  type        = string
  default     = null
}

variable "valkey_version" {
  description = "Valkey version"
  type        = string
}

variable "valkey_plan" {
  description = "Valkey plan (e.g. essential, production)"
  type        = string
}

variable "valkey_flavor" {
  description = "Valkey flavor (e.g. b3-8)"
  type        = string
}

variable "valkey_disk_size" {
  description = "Disk size in GB (optional, OVH default if null)"
  type        = number
  default     = null

  validation {
    condition = (
      var.valkey_disk_size == null ||
      (var.valkey_disk_size == floor(var.valkey_disk_size) && var.valkey_disk_size > 0)
    )
    error_message = "valkey_disk_size must be a positive integer when set."
  }
}

variable "valkey_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

############################################
# Backup & maintenance
############################################

variable "valkey_backup_time" {
  description = "Backup time (HH:MM format)"
  type        = string
  default     = null
}

variable "valkey_backup_regions" {
  description = "List of regions where backups are stored"
  type        = list(string)
  default     = null
}

############################################
# Advanced configuration
############################################

variable "valkey_advanced_configuration" {
  description = "Advanced Valkey configuration (Redis-compatible)"
  type        = map(string)
  default     = null
}

############################################
# Nodes
############################################

variable "valkey_nodes" {
  description = "List of Valkey nodes"
  type = list(object({
    region     = string
    network_id = string
    subnet_id  = string
  }))

  validation {
    condition     = length(var.valkey_nodes) >= 2
    error_message = "At least two Valkey nodes must be defined."
  }
}

############################################
# IP restrictions
############################################

variable "valkey_ip_restrictions" {
  description = "List of IP restrictions for Valkey access"
  type = list(object({
    ip          = string
    description = optional(string)
  }))
  default = null
}
