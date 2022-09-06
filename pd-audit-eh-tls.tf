resource "azurerm_policy_definition" "audit-eh-tls" {
  name         = "audit-eh-tls"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Event Hub Namespace required minimum version for TLS must be set to 1.2"
  description  = "This policy audits event hub namespace required minimum version for TLS must be set to 1.2 or higher. https://docs.microsoft.com/en-us/azure/event-hubs/transport-layer-security-configure-minimum-version"
  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "Governance",
    "fim-l2-ctrl": "DSEC.4",
    "priority": "P2",
    "source" : "Governance",
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
            "equals": "Microsoft.EventHub/namespaces"
          },
          {
            "field": "Microsoft.EventHub/namespaces/minimumTlsVersion",
            "notEquals": "1.2"
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

output "policydefinition_audit-eh-tls" {
  value = azurerm_policy_definition.audit-eh-tls
}