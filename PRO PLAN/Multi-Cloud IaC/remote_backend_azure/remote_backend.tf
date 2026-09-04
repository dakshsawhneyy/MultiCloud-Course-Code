terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0" # Keeps configuration locked to stable v4 minor updates
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demo" {
  name = "multicloud-demo-rg"
  location = "Central India"
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.rsg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.env
  }
}

resource "azurerm_storage_container" "container" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}
