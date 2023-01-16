resource "azurerm_policy_definition" "audit-smi-defender" {
  name         = "audit-smi-defender"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure SQL managed instances must have Defender enabled."
  description  = "This policy audits Azure SQL Managed Instance have Defender enabled."
  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-SMI-CTRL-15",
    "fim-l2-ctrl": "LOGM.1, LOGM.2, LOGM.3",
    "priority": "P2",
    "source" : "SCD",
    "exclude-reporting": "true",
    "exclude-from-alerts": "true"
    }

METADATA


  policy_rule = <<POLICY_RULE
{
"if": {
        "field": "type",
        "equals": "Microsoft.Sql/managedInstances"
    },
    "then": {
      "effect": "[parameters('effect')]",
          "details": {
          "type": "Microsoft.Sql/managedInstances/securityAlertPolicies",
          "name": "Default",
          "existenceCondition": {
            "field": "Microsoft.Sql/managedInstances/securityAlertPolicies/state",
            "equals": "Enabled"
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
          "description": "Enable or disable the execution of the policy"
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

output "policydefinition_audit-smi-defender" {
  value = azurerm_policy_definition.audit-smi-defender
}