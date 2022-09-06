resource "azurerm_policy_definition" "audit-eh-msg-ret" {
  name         = "audit-eh-msg-ret"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Event Hub Retention Periods MUST be set to the default 24 Hours unless authorised by Cybersecurity."
  description  = "This policy audits event hub retention periods that must be set to the default 24 Hours unless authorised by Cybersecurity. Event Hubs needing to retain data for longer than 24 hours will require Standard Tier Namespace which has an increased cost."

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-EH-CTRL-19",
    "fim-l2-ctrl": "DSEC.6",
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
            "equals": "Microsoft.EventHub/namespaces/eventhubs"
          },
          {
            "field": "Microsoft.EventHub/namespaces/eventhubs/messageRetentionInDays",
            "greater": 1
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
          "description": "The effect determines what happens when the policy rule is evaluated to match"
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

output "policydefinition_audit-eh-msg-ret" {
  value = azurerm_policy_definition.audit-eh-msg-ret
}