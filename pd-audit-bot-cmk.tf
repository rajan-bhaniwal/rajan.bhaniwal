resource "azurerm_policy_definition" "audit-bot-cmk" {
  name         = "audit-bot-cmk"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Bot Service with Data Classification Restricted or above and/or BIA Rating Major and above must be encrypted with a CMK"
  description  = "Bot Service with Data Classification Restricted or above and/or BIA Rating Major and above must be encrypted with customer-managed keys, also known as bring your own key (BYOK). Learn more about Azure Bot Service encryption: https://docs.microsoft.com/azure/bot-service/bot-service-encryption."

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-BOT-CTRL-10, AZR-BOT-CTRL-11",
    "fim-12-ctrl": "DSEC.4",
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
            "field": "Microsoft.BotService/botServices/isCmekEnabled",
            "notEquals": "true"
          },
          {
            "anyOf": [
              {
                "allOf": [
                  {
                  "field":"[concat('tags[', 'Data Classification', ']')]",
                  "exists": "true"
                  },
                  {
                  "field":"[concat('tags[', 'Data Classification', ']')]",
                  "in": "[parameters('dataClassification')]"
                  }
                ]
              },
              {
                "allOf": [
                  {
                  "field":"[concat('tags[', 'BIA', ']')]",
                  "exists": "true"
                  },
                  {
                  "field":"[concat('tags[', 'BIA', ']')]",
                  "in": "[parameters('biaRating')]"
                  }
                ]
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
      },
 "dataClassification": {
        "type": "Array",
        "metadata": {
          "displayName": "Data Classifictation",
          "description": "Data Classifictation Names to Apply"
        },
        "defaultValue": [
          "Restricted",
          "Highly Restricted"
        ]
      },
 "biaRating": {
        "type": "Array",
        "metadata": {
          "displayName": "BIA Rating",
          "description": "BIA Rating Names to Apply"
        },
        "defaultValue": [
          "Major",
          "Extreme"
        ]
      }
  }
PARAMETERS

}

output "policydefinition_audit-bot-cmk" {
  value = azurerm_policy_definition.audit-bot-cmk
}