resource "azurerm_policy_definition" "audit-smi-cmk" {
  name         = "audit-smi-cmk"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure SQL managed instances must use customer-managed keys to encrypt data at rest"
  description  = "This policy audits Azure SQL Managed Instance customer-managed keys encryption at rest. Implementing Transparent Data Encryption (TDE) with your own key provides you with increased transparency and control over the TDE Protector, increased security with an HSM-backed external service, and promotion of separation of duties. This recommendation applies to organizations with a related compliance requirement."
  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-SMI-CTRL-11, AZR-SMI-CTRL-12",
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
        "anyOf": [
          {
            "allOf": [
              {
                "field": "type",
                "equals": "Microsoft.Sql/managedInstances"
              },
              {
                "anyOf": [
                  {
                    "field": "Microsoft.Sql/managedInstances/keyid",
                    "exists": false
                  },
                  {
                    "field": "Microsoft.Sql/managedInstances/keyid",
                    "equals": ""
                  }
                ]
              }
            ]
          },
          {
            "allOf": [
              {
                "field": "type",
                "equals": "Microsoft.Sql/managedInstances/encryptionProtector"
              },
              {
                "field": "Microsoft.Sql/managedInstances/encryptionProtector/serverKeyType",
                "notequals": "AzureKeyVault"
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

output "policydefinition_audit-smi-cmk" {
  value = azurerm_policy_definition.audit-smi-cmk
}