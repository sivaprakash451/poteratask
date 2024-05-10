variable "project" {
  description = "The name of the project."
}

variable "environment" {
  description = "The environment (e.g., dev, test, prod)."
}

variable "resource_group_name" {
  description = "The name of the resource group."
}

variable "location" {
  description = "The Azure region where the resources will be provisioned."
}

variable "virtual_network_address_space" {
  description = "The address space for the virtual network."
}

variable "frontend_subnet_address_prefixes" {
  description = "The address prefixes for the frontend subnet."
}

variable "backend_subnet_address_prefixes" {
  description = "The address prefixes for the backend subnet."
}

variable "vmss_sku" {
  description = "The SKU for the virtual machine scale set."
}

variable "vmss_instances" {
  description = "The number of instances in the virtual machine scale set."
}

variable "vmss_image_publisher" {
  description = "The publisher of the VM image."
}

variable "vmss_image_offer" {
  description = "The offer of the VM image."
}

variable "vmss_image_sku" {
  description = "The SKU of the VM image."
}

variable "vmss_image_version" {
  description = "The version of the VM image."
}

variable "disk_storage_account_type" {
  description = "The type of the storage account for the managed disk."
}

variable "disk_size_gb" {
  description = "The size of the managed disk in gigabytes."
}

# PostgreSQL database variables
variable "postgresql_db_sku_name" {
  description = "The name of the SKU for the PostgreSQL database."
}

variable "postgresql_db_sku_capacity" {
  description = "The capacity of the SKU for the PostgreSQL database."
}

variable "postgresql_db_sku_tier" {
  description = "The tier of the SKU for the PostgreSQL database."
}

# Load Balancer variables
variable "lb_sku" {
  description = "The SKU for the load balancer."
}

# Storage Account variables
variable "storage_account_tier" {
  description = "The tier of the storage account."
}

variable "storage_account_replication_type" {
  description = "The replication type of the storage account."
}

variable "resource_tags" {
  description = "Tags to be applied to all resources."
  type        = map(string)
}
