#Azure Container Registry

variable "container_registry_name" { type = string }
variable "container_registry_sku" { type = string }

resource "azurerm_container_registry" "main" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.container_registry_sku
  admin_enabled       = true
}

output "ACR_URL" { value = azurerm_container_registry.main.login_server }
output "ACR_USERNAME" { value = azurerm_container_registry.main.admin_username }
output "ACR_PASSWORD" { value = azurerm_container_registry.main.admin_password }
