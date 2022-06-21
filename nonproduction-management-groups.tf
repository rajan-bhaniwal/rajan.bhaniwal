
module "management_groups" {
  source = "./modules/management_groups"
  count  = var.env == "nonprod" ? 1 : 0
  subscription_to_mg_csv_data = csvdecode(file("subs.csv"))
  # Non Prod Management Group
  management_groups = {
    "HSBC-NonProduction" = {
      "NonProduction-Landing-Zones" = {
        "NonProduction-Corp"          = {},
        "NonProduction-Corp-External" = {},
        "NonProduction-External"      = {},
        "NonProduction-VDI"           = {}
      },
      "NonProduction-Platform" = {
        "NonProduction-Management"   = {},
        "NonProduction-Connectivity" = {},
        "NonProduction-Identity"     = {}
      },
      "NonProduction-Staging"        = {},
      "NonProduction-Decommissioned" = {}
    }
  }
}

/**
data "azuread_client_config" "current" {}

data "azuread_service_principal" "spn" {
  display_name = "dev-spn"
}

resource "azuread_group" "Azure-Policy-Group" {
  display_name     = "Azure-EnterpriseScale-Policies-MSI-HSBC-NonProduction"
  security_enabled = true
  types            = ["Unified"]

  owners = [
    data.azuread_service_principal.spn.object_id
  ]
}

resource "azurerm_role_assignment" "assign" {
  scope                = "/providers/microsoft.management/managementgroups/HSBC-NonProduction"
  role_definition_name = "Contributer"
  principal_id         = data.azuread_client_config.current.object_id
}
**/