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

resource "azurerm_network_interface" "test" {
  name                = "test-nic"
  location            = "UK West"
  resource_group_name = "Project_RG"

  ip_configuration {
    name                          = "test-nic"
    subnet_id                     = "/subscriptions/aa32da49-0603-4855-b55b-bfd4bcf7b16f/resourceGroups/Project_RG/providers/Microsoft.Network/virtualNetworks/Project_VN/subnets/default"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "test" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = "Project_RG"
  location            = "UK West"
  allocation_method   = "Static"
}

resource "azurerm_virtual_machine" "test" {
  name                  = "test-VM"
  location              = "UK West"
  resource_group_name   = "Project_RG"
  network_interface_ids = [azurerm_network_interface.test.id]
  vm_size               = "Standard_B1ms"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

storage_image_reference {
    id = "/subscriptions/aa32da49-0603-4855-b55b-bfd4bcf7b16f/resourceGroups/Project_RG/providers/Microsoft.Compute/images/image-devops-practice"
  }
  storage_os_disk {
    name              = "test-vm-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "test-vm"
    admin_username = "azuser"
    admin_password = "Muniprasad@123"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }