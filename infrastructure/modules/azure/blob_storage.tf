#Azure Blob Storage

variable "storage_account_name" { type = string }
variable "storage_account_tier" { type = string }
variable "storage_account_replication_type" { type = string }

variable "storage_container_name" { type = string }
variable "storage_container_access_type" { type = string }

resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
}

resource "azurerm_storage_container" "main" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = var.storage_container_access_type
}

output "AZURE_ACCOUNT_NAME" { value = var.storage_account_name }
output "AZURE_ACCOUNT_KEY" { value = azurerm_storage_account.main.primary_access_key }
output "AZURE_CUSTOM_DOMAIN" { value = azurerm_storage_account.main.primary_blob_host }
output "AZURE_CONTAINER" { value = var.storage_container_name }
