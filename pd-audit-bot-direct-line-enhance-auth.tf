resource "azurerm_policy_definition" "audit-bot-direct-line-enhance-auth" {
  name         = "audit-bot-direct-line-enhance-auth"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit - Bot services, Enhanced authentication must be enabled when direct line channels are used."
  description  = "Enhanced authentication must be enabled when direct line channels are used."

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-BOT-CTRL-20, AZR-BOT-CTRL-21",
    "fim-12-ctrl": "NSEC.1",
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
            "count": {
              "field": "Microsoft.BotService/botServices/configuredChannels[*]",
              "where": {
                "equals": "directline",
                "field": "Microsoft.BotService/botServices/configuredChannels[*]"
              }
            },
            "greater": 0
          }
        ]
    },
    "then": {
      "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.BotService/botServices/channels",
          "existenceCondition": {
            "field": "Microsoft.BotService/botServices/channels/DirectLineChannel.sites[*].isSecureSiteEnabled",
            "equals": true
          }
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

output "policydefinition_audit-bot-direct-line-enhance-auth" {
  value = azurerm_policy_definition.audit-bot-direct-line-enhance-auth
}