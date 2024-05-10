terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
#Resource Group Creation
resource "azurerm_resource_group" "rg" {
  name     = "${var.project}-${var.environment}-rg"
  location = var.location
  tags     = var.resource_tags
}
#VNET Creation
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project}-${var.environment}-vnet"
  address_space       = var.virtual_network_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.resource_tags
}
#Frontend Subnet Creation
resource "azurerm_subnet" "frontend_subnet" {
  name                 = "${var.project}-${var.environment}-frontend-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.frontend_subnet_address_prefixes
  tags = {
    Name        = "${var.project}-${var.environment}-frontend-subnet"
    Environment = var.environment
    Project     = var.project
  }
}
#Backend subnet creation
resource "azurerm_subnet" "backend_subnet" {
  name                 = "${var.project}-${var.environment}-backend-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.backend_subnet_address_prefixes
  tags = {
    Name        = "${var.project}-${var.environment}-backend-subnet"
    Environment = var.environment
    Project     = var.project
  }
}
#Virtual Machine Scale set Creation
resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "${var.project}-${var.environment}-vmss"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.vmss_sku
  instances           = var.vmss_instances

  storage_profile_image_reference {
    publisher = var.vmss_image_publisher
    offer     = var.vmss_image_offer
    sku       = var.vmss_image_sku
    version   = var.vmss_image_version
  }

  network_profile {
    name    = azurerm_subnet.frontend_subnet.name
    primary = true
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    managed_disk_type    = "Standard_LRS"
    disk_size_gb         = var.disk_size_gb
    create_option        = "Empty"
    lun                  = 0
  }

  tags = {
    Name        = "${var.project}-${var.environment}-vmss"
    Environment = var.environment
    Project     = var.project
  }
}
#Azure Loadbalancer creation
resource "azurerm_lb" "lb" {
  name                = "${var.project}-${var.environment}-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.lb_sku
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
  tags = {
    Name        = "${var.project}-${var.environment}-lb"
     Environment = var.environment
    Project     = var.project
  }
}
#Azure LB Backend pool
resource "azurerm_lb_backend_address_pool" "vmss_backend_pool" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "${var.project}-${var.environment}-vmss-backend-pool"
}
#AzureLB Rule
resource "azurerm_lb_rule" "http" {
  name                        = "HTTP"
  resource_group_name         = azurerm_resource_group.rg.name
  loadbalancer_id             = azurerm_lb.lb.id
  frontend_ip_configuration_id = azurerm_lb.lb.frontend_ip_configuration[0].id
  backend_address_pool_id     = azurerm_lb_backend_address_pool.vmss_backend_pool.id
  frontend_port               = 80
  backend_port                = 80
  protocol                    = "Tcp"
}
#NIC Association
resource "azurerm_network_interface_backend_address_pool_association" "vmss_nic_backend_association" {
  count                    = var.vmss_instances
  network_interface_id     = azurerm_virtual_machine_scale_set.vmss.network_interface_ids[count.index]
  ip_configuration_name    = "ipconfig"
  backend_address_pool_id  = azurerm_lb_backend_address_pool.vmss_backend_pool.id
}
#Azure Managed Disk
resource "azurerm_managed_disk" "disk" {
  count                = var.vmss_instances
  name                 = "${var.project}-${var.environment}-disk-${count.index}"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = var.disk_storage_account_type
  create_option         = "Empty"
  disk_size_gb         = var.disk_size_gb
  tags = {
    Name        = "${var.project}-${var.environment}-disk-${count.index}"
    Environment = var.environment
    Project     = var.project
  }
}
#PostgreSQL Creation
resource "azurerm_postgresql_database" "postgresql_db" {
  name                = "${var.project}-${var.environment}-db"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = var.postgresql_db_sku_name
  sku_capacity        = var.postgresql_db_sku_capacity
  sku_tier            = var.postgresql_db_sku_tier
  tags = {
    Name        = "${var.project}-${var.environment}-db"
    Environment = var.environment
    Project     = var.project
  }
}
#Storage account
resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.project}${var.environment}sa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  tags = {
    Name        = "${var.project}${var.environment}sa"
    Environment = var.environment
    Project     = var.project
  }
}
#Tagging
resource "azurerm_resource_group_tag" "tag" {
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.resource_tags
}
#VMSS Public IP
output "vmss_public_ip" {
  value = azurerm_virtual_machine_scale_set.vmss.public_ip_address
}
