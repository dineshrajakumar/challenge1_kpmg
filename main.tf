
/*
The Below TF Code assumes the connection between the TF and Azure is established via AzureSPN v
*/
provider "azurerm" {
  version = "~> 2.0.0"
  features {}
}

resource "azurerm_resource_group" "KPMGRG" {
  name     = "KPMGTest"
  location = "West Europe"
}

resource "azurerm_virtual_network" "KPMGVN" {
  name                = "KPMG-VR-template"
  address_space       = ["40.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}


resource "azurerm_subnet" "KPMGSNET" {
  name                 = "KPMG-web-dev"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["40.0.2.0/24"]
}


resource "azurerm_availability_set" "KPMGWebAVSet" {
  name                = "KPMG-web-av"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  tags = {
    environment = "dev"
  }
}


resource "azurerm_availability_set" "KPMGAppAVSet" {
  name                = "KPMG-app-av"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  tags = {
    environment = "dev"
  }
}

resource "azurerm_availability_set" "KPMGDBAVSet" {
  name                = "KPMG-DB-av"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_account" "KPMGSAC" {
  name                     = "KPMG-dev-storage"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "dev"
  }
}

//I had used TFE Enterprise Modules to build the  VMs here 

module "vm-linux_01_Web" {
  source                           = "tfe.XXX.com/XXX-Service/vm-linux-avzones/azurerm"
  version                           = "6.1.1-2-0.12"
  name                             = var.user_parameters.vm_name_01
  location                         = var.__ghs.hosting_location
  resource_group_name              = var.__ghs.environment_resource_groups
  subnet_id                        = data.azurerm_subnet.subnet.id
  ip_address                       = null
  ip_configuration_name            = "TEST_Config_Name"
  boot_diagnostics_storage_acc_uri = "https://storageaccountname.blob.core.windows.net/"
  source_image_id                  = "/subscriptions/subscription-ID/resourceGroups/RGNAME/XXX/images/AZU_CENTOS_Base"
  admin_username                   = "AdminAzure013"
  admin_password                   = "Pa$$w0rd"
  size                             = "Standard_D3_v2"
  osdisk_storage_account_type      = "Standard_LRS"
  osdisk_size_gb                   = "128"
  zone                             = 1
  vm_count                         = 1
  tags                             = var.system_parameters.TAGS
}

module "vm-APP" {
  source  = "tfe.XXX.com/XXX-Service/vm-windows/azurerm"
  version = "5.0.1-2-0.12"
  location                         = var.__ghs.hosting_location
  ip_configuration_name            = var.user_parameters.ip_configuration_name
  subnetid                         = data.azurerm_subnet.subnet.id
  ipaddress                        = "10.198.4.XX"
  hostname                         = var.user_parameters.vm_win_name_01
  resource_group_name              = var.__ghs.environment_resource_groups
  size                             = var.user_parameters.vm_size
  availability_set_id              = module.availabilityset_01.id
  password                         = var.user_parameters.password
  source_image_id                  = "/subscriptions/SUBSCRIPTIONID/resourceGroups/RGNAME/providers/images/AZU_Win2k16_Base"
  osdisk_managed_disk_type         = "Standard_LRS"
  osdisk_managed_disk_size         = 150
  boot_diagnostics_storage_acc_uri = module.storage_account_01.primary_blob_endpoint
  license_type                     = "None"
  tags                             = var.system_parameters.TAGS
} 


module "vm-DB" {
  source  = "tfe.XXX.com/XXX-Service/vm-windows/azurerm"
  version = "5.0.1-2-0.12"
  location                         = var.__ghs.hosting_location
  ip_configuration_name            = var.user_parameters.ip_configuration_name
  subnetid                         = data.azurerm_subnet.subnet.id
  ipaddress                        = "10.198.4.XX"
  hostname                         = var.user_parameters.vm_win_name_01
  resource_group_name              = var.__ghs.environment_resource_groups
  size                             = var.user_parameters.vm_size
  availability_set_id              = module.availabilityset_01.id
  password                         = var.user_parameters.password
  source_image_id                  = "/subscriptions/SUBSCRIPTIONID/resourceGroups/RGNAME/providers/images/AZU_Win2k16_Base"
  osdisk_managed_disk_type         = "Standard_LRS"
  osdisk_managed_disk_size         = 150
  boot_diagnostics_storage_acc_uri = module.storage_account_01.primary_blob_endpoint
  license_type                     = "None"
  tags                             = var.system_parameters.TAGS
} 
  