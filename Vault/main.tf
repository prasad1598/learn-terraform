data "vault_generic_secret" "ssh" {
  path = "roboshop-infra/ssh"
}

provider "vault" {
  address = "http://vault-int.prasaddevops.shop:8200"
  token   = var.token
}

resource "local_file" "foo" {
  content  = data.vault_generic_secret.ssh.data["password"]
  filename = "/tmp/vault"
}

variable "token" {}