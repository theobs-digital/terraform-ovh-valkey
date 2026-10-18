variable "service_name" {
  description = "ID of the OVHcloud Public Cloud project."
  type        = string
}

variable "network_id" {
  description = "OpenStack ID of the private network (vRack) in the region of the nodes, not its `pn-…` ID: the `openstackid` of that region in `regions_attributes` of `ovh_cloud_project_network_private`."
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet of the nodes."
  type        = string
}
