terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1. Resource Group (Azure's mandatory wrapper)
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# 2. Your Registry
resource "azurerm_container_registry" "app" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
}

# 3. Create the SSH Public Key Resource in Azure
resource "azurerm_ssh_public_key" "vm_key" {
  name                = "demo-azure-key"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  
  # This uses a local key you already have. 
  # If you don't have one, run 'ssh-keygen -t rsa -b 4096' in your terminal first.
  public_key          = file("~/.ssh/id_rsa.pub")
}

# 4. Simple VM linking to the new key
resource "azurerm_virtual_machine" "web" {
  name                  = "terraform-demo-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  vm_size               = "Standard_B1s"
  network_interface_ids = [] 

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "azureuser"
  }

  # Link the generated Azure SSH key block here
  os_profile_linux_config {
    disable_password_authentication = true
    
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = azurerm_ssh_public_key.vm_key.public_key
    }
  }
}

