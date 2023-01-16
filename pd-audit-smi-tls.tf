resource "azurerm_policy_definition" "audit-smi-tls" {
  name         = "audit-smi-tls"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure SQL Managed Instance must have the minimal TLS version of 1.2"
  description  = "This policy audits Azure SQL Managed Instance TLS version of 1.2. Setting minimal TLS version to 1.2 improves security by ensuring your SQL Managed Instance can only be accessed from clients using TLS 1.2. Using versions of TLS less than 1.2 is not recommended since they have well documented security vulnerabilities."
  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-SMI-CTRL-14, AZR-SMI-CTRL-16",
    "fim-l2-ctrl": "DSEC.1, DSEC.4, DSEC.5",
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
                "field": "Microsoft.Sql/managedInstances/minimalTlsVersion",
                "exists": false
              },
              {
                "field": "Microsoft.Sql/managedInstances/minimalTlsVersion",
                "notEquals": "1.2"
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

output "policydefinition_audit-smi-tls" {
  value = azurerm_policy_definition.audit-smi-tls
}