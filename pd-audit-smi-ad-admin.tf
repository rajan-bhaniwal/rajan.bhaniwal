resource "azurerm_policy_definition" "audit-smi-ad-admin" {
  name         = "audit-smi-ad-admin"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure SQL Managed Instance must have Azure Active Directory Only Authentication enabled"
  description  = "This policy audits Azure SQL Managed Instance Active Directory administrator must be provisioned for Azure AD authentication.Azure AD authentication enables simplified permission management and centralized identity management of database users and other Microsoft services."

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-SMI-CTRL-02,AZR-SMI-CTRL-05,AZR-SMI-CTRL-06, AZR-SMI-CTRL-07",
    "fim-l2-ctrl": "IDAM.3, IDAM.4, IDAM.5",
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
            "equals": "Microsoft.Sql/managedInstances"
          },
          {
            "anyOf": [
              {
                "field": "Microsoft.Sql/managedInstances/administrators.azureADOnlyAuthentication",
                "exists": false
              },
              {
                "field": "Microsoft.Sql/managedInstances/administrators.azureADOnlyAuthentication",
                "equals": "false"
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
          "description": "Enable or disable the execution of the policy"
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

output "policydefinition_audit-smi-ad-admin" {
  value = azurerm_policy_definition.audit-smi-ad-admin
}