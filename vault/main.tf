provider "vault" {
  address = "http://vault-int.prasaddevops.shop:8200"
  token   = var.token
}

data "vault_generic_secret" "ssh" {
  path = "roboshop-infra/ssh"
}

resource "local_file" "ssh" {
  content  = data.vault_generic_secret.ssh.data["password"]
  filename = "/tmp/vault"
}

resource "local_file" "foo" {
  content  = jsonencode(data.vault_generic_secret.ssh.data["password"])
  filename = "/tmp/vault1"
}

variable "token" {}