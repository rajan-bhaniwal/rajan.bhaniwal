resource "azurerm_policy_definition" "audit-eh-auth" {
  name         = "audit-eh-auth"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Event Hub service must have Authorization rules defined"
  description  = "This policy audits existence of authorization rules on Event Hub entities to grant least-privileged access"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-EH-CTRL-02, AZR-EH-CTRL-03, AZR-EH-CTRL-04, AZR-EH-CTRL-07,AZR-EH-CTRL-09, AZR-EH-CTRL-16",
    "fim-l2-ctrl": "IDAM.3, IDAM.5",
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
          }
        ]
    },
    "then": {
      "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.EventHub/namespaces/eventHubs/authorizationRules",
          "existenceCondition": {
            "field": "Microsoft.EventHub/namespaces/eventhubs/authorizationrules/rights",
            "exists": true
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

output "policydefinition_audit-eh-auth" {
  value = azurerm_policy_definition.audit-eh-auth
}