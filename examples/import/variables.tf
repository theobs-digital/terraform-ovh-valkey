variable "service_name" {
  description = "ID of the OVHcloud Public Cloud project."
  type        = string
}

variable "cluster_id" {
  description = "ID of the existing Valkey database."
  type        = string
}

variable "user_id" {
  description = "ID of the existing user `app`."
  type        = string
}
