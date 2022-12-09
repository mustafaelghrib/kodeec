variable "github" {
  type    = map(string)
  default = {
    token = ""
  }
}

provider "github" {
  token = var.github.token
}

variable "environments" {
  type    = map(map(string))
  default = {
    production = {}
  }
}

module "github" {
  for_each            = var.environments
  source              = "./modules/github"
  repository_name     = "mstva/kodeec"
  environment_name    = "${local.project_name}-${each.key}-environment"
  environment_secrets = each.value
}
