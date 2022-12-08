variable "github" {
  type    = map(string)
  default = {
    token = ""
  }
}

provider "github" {
  token = var.github.token
}
