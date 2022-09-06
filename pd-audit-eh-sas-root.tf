resource "azurerm_policy_definition" "audit-eh-sas-root" {
  name         = "audit-eh-sas-root"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Event Hub Namespace must remove all authorization rules except RootManageSharedAccessKey"
  description  = "This policy audits Event Hub namespace level access policy that provides access to all queues and topics in a namespace. To align with the least privilege security model, you must create access policies at the entity level for queues and topics to provide access to only the specific entity."

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-EH-CTRL-16",
    "fim-l2-ctrl": "IDAM.3",
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
            "equals": "Microsoft.EventHub/namespaces/authorizationRules"
          },
          {
            "field": "name",
            "notEquals": "RootManageSharedAccessKey"
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

output "policydefinition_audit-eh-sas-root" {
  value = azurerm_policy_definition.audit-eh-sas-root
}