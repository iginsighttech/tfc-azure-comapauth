terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~>3.14.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~>0.54.0"
    }
  }
}

provider "tfe" {
  hostname = var.tfc_hostname
  token    = var.tfc_token
}

provider "vault" {
  address   = var.vault_addr
  namespace = var.vault_namespace
  token     = var.vault_token
}