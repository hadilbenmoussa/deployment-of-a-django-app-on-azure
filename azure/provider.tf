terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"

    }

  }

  backend "azurerm" {
    resource_group_name  = "tfstateRG01"
    storage_account_name = "tfstate011072135289"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
provider "azurerm" {
  features {

  }

}