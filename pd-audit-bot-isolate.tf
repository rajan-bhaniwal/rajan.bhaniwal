resource "azurerm_policy_definition" "audit-bot-isolate" {
  name         = "audit-bot-isolate"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Bot Service must have isolated mode enabled"
  description  = "Bots must be set to 'isolated only' mode. This setting configures Bot Service channels that require traffic over the public internet to be disabled."

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-BOT-CTRL-12,AZR-BOT-CTRL-13",
    "fim-12-ctrl": "NSEC.1, DSEC.4",
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
            "equals": "Microsoft.BotService/botServices"
          },
          {
            "field": "Microsoft.BotService/botServices/publicNetworkAccess",
            "notEquals": "Disabled"
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
          "description": "The desired effect of the policy."
        },
        "allowedValues": [
          "audit",
          "Audit",
          "deny",
          "Deny",
          "disabled",
          "Disabled"
        ],
        "defaultValue": "Audit"
      }
  }
PARAMETERS

}

output "policydefinition_audit-bot-isolate" {
  value = azurerm_policy_definition.audit-bot-isolate
}