#Azure Database for PostgresSQL

variable "database_server_name" { type = string }
variable "database_server_sku_name" { type = string }
variable "database_server_storage" { type = string }
variable "database_server_version" { type = string }
variable "database_server_username" { type = string }
variable "database_server_password" { type = string }

variable "database_name" { type = string }
variable "database_charset" { type = string }
variable "database_collation" { type = string }

resource "azurerm_postgresql_server" "main" {
  name                = var.database_server_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  administrator_login          = var.database_server_username
  administrator_login_password = var.database_server_password

  sku_name   = var.database_server_sku_name
  storage_mb = var.database_server_storage
  version    = var.database_server_version

  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_postgresql_database" "main" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.main.name
  charset             = var.database_charset
  collation           = var.database_collation
}

output "POSTGRES_DB" { value = var.database_name }
output "POSTGRES_USER" { value = "${var.database_server_username}@${azurerm_postgresql_server.main.fqdn}" }
output "POSTGRES_PASSWORD" { value = var.database_server_password }
output "POSTGRES_HOST" { value = azurerm_postgresql_server.main.fqdn }
output "POSTGRES_PORT" { value = "5432" }
