resource "azurerm_policy_definition" "audit-bot-pvl" {
  name         = "audit-bot-pvl"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Bot Service resources should use private link"
  description  = "Azure Private Link lets you connect your virtual network to Azure services without a public IP address at the source or destination. The Private Link platform handles the connectivity between the consumer and services over the Azure backbone network. By mapping private endpoints to your BotService resource, data leakage risks are reduced."

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-BOT-CTRL-12, AZR-BOT-CTRL-13",
    "fim-12-ctrl": "DSEC.4, NSEC.1",
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
              "field": "Microsoft.BotService/botServices/privateEndpointConnections[*]",
              "where": {
                "field": "Microsoft.BotService/botServices/privateEndpointConnections[*].privateLinkServiceConnectionState.status",
                "equals": "Approved"
              }
            },
            "less": 1
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
          "disabled",
          "Disabled"
        ],
        "defaultValue": "Audit"
      }
  }
PARAMETERS

}

output "policydefinition_audit-bot-pvl" {
  value = azurerm_policy_definition.audit-bot-pvl
}