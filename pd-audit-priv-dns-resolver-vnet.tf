resource "azurerm_policy_definition" "audit-priv-dns-res-vnet" {
  name         = "audit-priv-dns-res-vnet"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Private DNS resolver inbound and outbound endpoint must be attached to an approved ACST managed vNet."
  description  = "Private DNS resolver inbound and outbound endpoint must be attached to an approved ACST managed vNet."


  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-DPR-CTRL-06, AZR-DPR-CTRL-07",
    "fim-l2-ctrl": "ITOP.2",
    "priority": "P2",
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
          "equals": "Microsoft.Network/dnsResolvers"
        },
        {
          "field": "Microsoft.Network/dnsResolvers/virtualNetwork.id",
          "notIn": "[parameters('approvedVNetIDs')]"
        }
      ]
    },
    "then": {
      "effect": "[parameters('effect')]"
    }
  }
POLICY_RULE

  parameters = <<PARAMETERS
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
    },
    "approvedVNetIDs": {
      "type": "Array",
      "metadata": {
        "displayName": "List of approved vNet IDs",
        "description": "List of approved ACST managed vNet IDs"
      },
      "defaultValue": []
    }
  }
PARAMETERS

}

output "policydefinition_audit-priv-dns-res-vnet" {
  value = azurerm_policy_definition.audit-priv-dns-res-vnet
}