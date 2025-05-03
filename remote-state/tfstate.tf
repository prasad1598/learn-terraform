terraform {
  backend "azurerm" {
    subscription_id      = "aa32da49-0603-4855-b55b-bfd4bcf7b16f"
    resource_group_name  = "project_rg"
    storage_account_name = "terratfstateform"
    container_name       = "roboshop-tfstate-files"
    key                  = "test.terraform.tfstate"
  }
}