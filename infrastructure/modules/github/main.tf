terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

variable "repository_name" { type = string }
variable "environment_name" { type = string }
variable "environment_secrets" { type = map(string) }

data "github_repository" "main" {
  full_name = var.repository_name
}

resource "github_repository_environment" "main" {
  repository  = data.github_repository.main.name
  environment = var.environment_name
}

resource "github_actions_environment_secret" "main" {
  for_each        = var.environment_secrets
  repository      = data.github_repository.main.name
  environment     = github_repository_environment.main.environment
  secret_name     = each.key
  plaintext_value = each.value
}
