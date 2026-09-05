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
# Virtual Machine
resource "azurerm_virtual_machine" "web" {
  name                  = "terraform-demo-vm"
  location              = azurerm_resource_group.demo.location
  resource_group_name   = azurerm_resource_group.demo.name
  vm_size               = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.demo.id] 

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
    # 1. Add your password here (use a variable for security)
    admin_password = "admin123"
  }

  os_profile_linux_config {
    # 2. Change this to false to allow password logins
    disable_password_authentication = false 
  }
}
