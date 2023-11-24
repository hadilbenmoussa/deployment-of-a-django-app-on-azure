
output "azurerm_container_app_url" {
  value = azurerm_container_app.containerapp.latest_revision_fqdn
}
