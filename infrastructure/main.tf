terraform {
  required_version = "1.3.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.30.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
  backend "azurerm" {}
}

locals { project_name = "kodeec" }
