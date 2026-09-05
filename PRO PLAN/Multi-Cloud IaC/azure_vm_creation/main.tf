(* Create a Resource Group *)
resource "azurerm_resource_group" "main" {
  name     = "terraform-demo-rg"
  location = "Central India"
}


(* Create a Virtual Network *)
resource "azurerm_virtual_network" "main" {
  name                = "terraform-demo-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

(* Create a Subnet *)
resource "azurerm_subnet" "main" {
  name                 = "terraform-demo-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

(* Create a Network Interface *)
resource "azurerm_network_interface" "main" {
  name                = "terraform-demo-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

(* Create the Linux VM *)
resource "azurerm_linux_virtual_machine" "main" {
  name                = "terraform-demo-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B1s"

  admin_username = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.main.id
  ]

  admin_password = "ChangeThisToAStrongPassword123!"

  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
