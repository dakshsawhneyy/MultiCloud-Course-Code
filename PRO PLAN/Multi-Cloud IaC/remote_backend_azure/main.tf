terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
    }
  }
}

# Initialization
provider "azurerm" {
  features {}
}



data "azurerm_resource_group" "demo" {
  name = "multicloud-demo-rg"
}

# Azure Storage Account
resource "azurerm_storage_account" "demo" {
  name = "terraformdemosa"
  resource_group_name = azurerm_resource_group.demo.name
  location = azurerm_resource_group.demo.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}


terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "terraformstateUNIQUEID"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
