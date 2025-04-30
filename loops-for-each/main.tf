variable "node" {
  default = {
    test1 = {
      vm_size = "Standard_B1ms"
    }
    test2 = {
      vm_size = "Standard_B1ms"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "aa32da49-0603-4855-b55b-bfd4bcf7b16f"
}

resource "azurerm_network_interface" "privateip" {
  for_each            = var.node
  name                = "${each.key}-ip"
  location            = "UK West"
  resource_group_name = "Project_RG"

  ip_configuration {
    name                          = "${each.key}-ip"
    subnet_id                     = "/subscriptions/aa32da49-0603-4855-b55b-bfd4bcf7b16f/resourceGroups/Project_RG/providers/Microsoft.Network/virtualNetworks/Project_VN/subnets/default"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "NSG_attach" {
  for_each                  = var.node
  network_interface_id      = azurerm_network_interface.privateip[each.key].id
  network_security_group_id = "/subscriptions/aa32da49-0603-4855-b55b-bfd4bcf7b16f/resourceGroups/Project_RG/providers/Microsoft.Network/networkSecurityGroups/Project_NSG"
}

resource "azurerm_virtual_machine" "vm" {
  for_each            = var.node
  name                  = "${each.key}-vm"
  location            = "UK West"
  resource_group_name = "Project_RG"
  network_interface_ids = [azurerm_network_interface.privateip[each.key].id]
  vm_size               = each.value["vm_size"]

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = "/subscriptions/aa32da49-0603-4855-b55b-bfd4bcf7b16f/resourceGroups/Project_RG/providers/Microsoft.Compute/images/test-devops-practice"
  }
  storage_os_disk {
    name              = "${each.key}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${each.key}"
    admin_username = "azuser"
    admin_password = "Muniprasad@123"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}