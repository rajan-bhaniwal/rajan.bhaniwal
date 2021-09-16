resource "azurerm_policy_definition" "audit-aci-vnet" {
  name         = "audit-aci-vnet"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Azure Container Instance container group must be deploy into a virtual network"
  description  = "Secure communication between your containers with Azure Virtual Networks. When you specify a virtual network, resources within the virtual network can securely and privately communicate with each other."

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ACI-CTRL-21",
    "fim-12-ctrl": "NSEC.1",
    "priority": "P1",
    "source" : "SCD",
    "exclude-reporting": "true",
    "exclude-from-alerts": "true"
    }
METADATA


  policy_rule = <<POLICY_RULE
    {
    "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.ContainerInstance/containerGroups"
          },
          {
            "field": "Microsoft.ContainerInstance/containerGroups/networkProfile.id",
            "exists": false
          }
        ]
    },
    "then": {
    "effect": "Audit"
  }
 }
POLICY_RULE
}

output "policydefinition_audit-aci-vnet" {
  value = azurerm_policy_definition.audit-aci-vnet
}