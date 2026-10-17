variable "service_name" {
  description = "ID of the OVHcloud Public Cloud project."
  type        = string
}

variable "network_id" {
  description = "ID of the private network (vRack) the nodes join."
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet of the nodes."
  type        = string
}
