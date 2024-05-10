project = "my-test-project"
environment = "dev"
resource_group_name = "my-resource-group"

location = "East US"
virtual_network_address_space = ["10.0.0.0/16"]
frontend_subnet_address_prefixes = ["10.0.1.0/24"]
backend_subnet_address_prefixes = ["10.0.2.0/24"]

vmss_sku = "Standard_DS2_v2"
vmss_instances = 2
vmss_image_publisher = "Canonical"
vmss_image_offer = "UbuntuServer"
vmss_image_sku = "18.04-LTS"
vmss_image_version = "latest"

disk_storage_account_type = "Standard_LRS"
disk_size_gb = 128

postgresql_db_sku_name = "B_Gen5_1"
postgresql_db_sku_capacity = 1
postgresql_db_sku_tier = "Basic"

lb_sku = "Standard"

storage_account_tier = "Standard"
storage_account_replication_type = "LRS"

resource_tags = {
  Environment = "Development"
  Project     = "my-test-project"
}
