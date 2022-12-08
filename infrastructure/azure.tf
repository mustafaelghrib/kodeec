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
