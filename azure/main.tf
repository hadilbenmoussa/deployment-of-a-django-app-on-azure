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

resource "azurerm_resource_group" "rg" {
  name     = "devops-task-rg"
  location = "eastus"
}

resource "azurerm_log_analytics_workspace" "loganalytics" {
  name                = "devops-task-la"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
data "azurerm_container_registry" "acr" {
  name                = "devopstask001"
  resource_group_name = "RG01"
}
resource "azurerm_container_app_environment" "containerappenv" {
  name                       = "devops-task-containerappenv"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.loganalytics.id
}
resource "azurerm_user_assigned_identity" "containerapp" {
  location            = azurerm_resource_group.rg.location
  name                = "containerappmi"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "containerapp" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "acrpull"
  principal_id         = azurerm_user_assigned_identity.containerapp.principal_id
  depends_on = [
    azurerm_user_assigned_identity.containerapp
  ]
}
resource "azurerm_container_app" "containerapp" {
  name                         = "devops-task-app"
  container_app_environment_id = azurerm_container_app_environment.containerappenv.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Multiple"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.containerapp.id]
  }

  registry {
    server   = data.azurerm_container_registry.acr.login_server
    identity = azurerm_user_assigned_identity.containerapp.id
  }
  ingress {
    allow_insecure_connections = true

    external_enabled = true
    target_port      = 8000
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
  template {
    container {
      name   = "firstcontainerappacracr"
      image  = "${data.azurerm_container_registry.acr.login_server}/django-todolist:v2"
      cpu    = 0.25
      memory = "0.5Gi"
    }


  }



}
output "azurerm_container_app_url" {
  value = azurerm_container_app.containerapp.latest_revision_fqdn
}
