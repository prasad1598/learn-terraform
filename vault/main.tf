provider "vault" {
  address = "http://51.141.85.111:8200"
  token   = var.token
}

data "vault_generic_secret" "ssh" {
  path = "ssh/login"
}

resource "local_file" "ssh" {
  content  = data.vault_generic_secret.ssh.data
  filename = "/tmp/vault"
}

resource "local_file" "foo" {
  content  = jsonencode(data.vault_generic_secret.ssh.data)
  filename = "/tmp/vault1"
}

variable "token" {}