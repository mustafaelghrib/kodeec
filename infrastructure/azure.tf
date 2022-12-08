variable "azure" {
  type    = map(string)
  default = {
    subscription_id = ""
    tenant_id       = ""
    client_id       = ""
    client_secret   = ""
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.azure.subscription_id
  tenant_id       = var.azure.tenant_id
  client_id       = var.azure.client_id
  client_secret   = var.azure.client_secret
}

variable "database_server_password" { type = string }

module "azure" {
  source = "./modules/azure"

  resource_group_name     = "${local.project_name}-resource-group"
  resource_group_location = "East US"

  database_server_name     = "${local.project_name}-database-server"
  database_server_username = "${local.project_name}_db_user"
  database_server_password = var.database_server_password
  database_server_sku_name = "B_Gen5_2"
  database_server_storage  = "5120"
  database_server_version  = "11"

  database_name      = "${local.project_name}_db"
  database_charset   = "UTF8"
  database_collation = "English_United States.1252"

  network_name                = "${local.project_name}-virtual-network"
  network_subnet_name         = "${local.project_name}-subnet"
  network_public_ip_name      = "${local.project_name}-public-ip"
  network_security_group_name = "${local.project_name}-security-group"
  network_interface_name      = "${local.project_name}-network-interface"

  machine_name                    = "${local.project_name}-machine"
  machine_username                = "${local.project_name}_user"
  machine_size                    = "Standard_DS1_v2"
  machine_os_caching              = "ReadWrite"
  machine_os_storage_account_type = "Standard_LRS"
  machine_image_publisher         = "Canonical"
  machine_image_offer             = "0001-com-ubuntu-server-focal"
  machine_image_sku               = "20_04-lts-gen2"
  machine_image_version           = "latest"

  machine_ssh_public_key  = file("${path.module}/.ssh/id_rsa.pub")
  machine_ssh_private_key = file("${path.module}/.ssh/id_rsa")
  machine_scripts         = ["./scripts/install_docker.sh"]

  container_registry_name = "${local.project_name}registry"
  container_registry_sku  = "Basic"

}

output "azure" {
  value     = module.azure
  sensitive = true
}
