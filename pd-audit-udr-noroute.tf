resource "azurerm_policy_definition" "audit-udr-route" {
  name         = "audit-udr-route"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "UDR must have a route defined. UDR's without any routes defined allows traffic to use Azure default routes."
  description  = "UDR must have a route defined. UDR's without any routes defined allows traffic to use Azure default routes."



  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "Governanace",
    "fim-l2-ctrl": "Governanace",
    "priority": "P2",
    "source" : "Governanace",
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
                "equals": "Microsoft.Network/routeTables"
            }
        ]
    },
    "then": {
      "effect":  "[parameters('effect')]",
      "details": {
        "type": "Microsoft.Network/routeTables/routes"
      }
    }
  }
POLICY_RULE
  parameters = <<PARAMETERS
  {
 "effect": {
        "type": "String",
        "metadata": {
          "displayName": "Effect",
          "description": "The desired effect of the policy."
        },
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "defaultValue": "AuditIfNotExists"
      }
  }
PARAMETERS
}

output "policydefinition_audit-udr-route" {
  value = azurerm_policy_definition.audit-udr-route
}