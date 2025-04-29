provider "azurerm" {
  features {}
  subscription_id = "aa32da49-0603-4855-b55b-bfd4bcf7b16f"
}

# resource "azurerm_subnet" "test" {
#   name                 = "test-SN"
#   resource_group_name  = "Project_RG"
#   virtual_network_name = "Project_VN"
#   address_prefixes     = ["10.0.2.0/24"]
# }

resource "azurerm_network_interface" "demo" {
  name                = "demo-nic"
  location            = "UK West"
  resource_group_name = "Project_RG"

  ip_configuration {
    name                          = "demo-nic"
    subnet_id                     = "/subscriptions/aa32da49-0603-4855-b55b-bfd4bcf7b16f/resourceGroups/Project_RG/providers/Microsoft.Network/virtualNetworks/Project_VN/subnets/default"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "demo" {
  name                = "demo-ip"
  resource_group_name = "Project_RG"
  location            = "UK West"
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_machine" "demo" {
  name                = "demo-VM"
  location            = "UK West"
  resource_group_name = "Project_RG"
  network_interface_ids = [azurerm_network_interface.demo.id]
  vm_size = "Standard_B1ms"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true
}

storage_image_reference {
    id = "/subscriptions/aa32da49-0603-4855-b55b-bfd4bcf7b16f/resourceGroups/Project_RG/providers/Microsoft.Compute/images/test-devops-practice"
  }
storage_os_disk {
  name              = "demo-vm-disk"
  caching           = "ReadWrite"
  create_option     = "FromImage"
  managed_disk_type = "Standard_LRS"
}
os_profile {
  computer_name  = "demo-vm"
  admin_username = "azuser"
  admin_password = "Muniprasad@123"
}
os_profile_linux_config {
  disable_password_authentication = false
}