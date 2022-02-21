resource "azurerm_policy_definition" "audit-vnet-peering-extmg" {
  name         = "audit-vnet-peering-extmg"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Vnet peering is disallowed outside of current subscription"
  description  = "Network peering must not be associated to networks outside of the current subscription"


  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "Governance",
    "fim-12-ctrl": "Governance",
    "priority": "P1",
    "source" : "Governance",
    "exclude-reporting": "true",
    "exclude-from-alerts": "true"
    }

METADATA


  policy_rule = <<POLICY_RULE

    {
    "if": {
      "anyOf": [
        {
          "allOf": [
            {
              "equals": "Microsoft.Network/virtualNetworks/virtualNetworkPeerings",
              "field": "type"
            },
            {
              "field": "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/remoteVirtualNetwork.id",
              "notcontains": "[subscription().subscriptionId]"
            }
          ]
        },
        {
          "allOf": [
            {
              "equals": "Microsoft.Network/virtualNetworks",
              "field": "type"
            },
            {
              "field": "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/remoteVirtualNetwork.id",
              "notcontains": "[subscription().subscriptionId]"
            }
          ]
        }
      ]
    },
    "then": {
      "effect": "[parameters('effect')]"
      }
  }
POLICY_RULE

  parameters  = <<PARAMETERS
  {
    "effect": {
      "type": "String",
      "metadata": {
        "displayName": "Effect",
        "description": "Enable or disable the execution of the policy"
      },
      "allowedValues": [
        "Audit",
        "Deny",
        "Disabled"
      ],
      "defaultValue": "Audit"
    }
  }
PARAMETERS

}

output "policydefinition_audit-vnet-peering-extmg" {
  value = azurerm_policy_definition.audit-vnet-peering-extmg
}