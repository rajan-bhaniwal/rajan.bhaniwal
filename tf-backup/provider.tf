terraform {
  required_version = ">= 0.13.2"
}

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {
    virtual_machine {
      delete_os_disk_on_deletion = true
    }
  }
  version = "2.38.0"
}

provider "azuread" {
  version = "2.6.0"
}
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
