resource "azurerm_policy_definition" "audit-dbmysql-cmk" {
  name         = "audit-dbmysql-cmk"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure MySQL servers must use customer-managed keys to encrypt data at rest"
  description  = "This policy audits MySQL servers customer-managed keys to encrypt data at rest. Use customer-managed keys to manage the encryption at rest of your MySQL servers. By default, the data is encrypted at rest with service-managed keys, but customer-managed keys are commonly required to meet regulatory compliance standards. Customer-managed keys enable the data to be encrypted with an Azure Key Vault key created and owned by you."

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-DBSQL-CTRL-10",
    "fim-l2-ctrl": "DSEC.3, DSEC.5",
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
            "equals": "Microsoft.DBforMySQL/servers"
          }
        ]
    },
    "then": {
      "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.DBforMySQL/servers/keys",
          "existenceCondition": {
            "allOf": [
              {
                "field": "Microsoft.DBforMySQL/servers/keys/serverKeyType",
                "equals": "AzureKeyVault"
              },
              {
                "field": "Microsoft.DBforMySQL/servers/keys/uri",
                "notEquals": ""
              },
              {
                "field": "Microsoft.DBforMySQL/servers/keys/uri",
                "exists": "true"
              }
            ]
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

output "policydefinition_audit-dbmysql-cmk" {
  value = azurerm_policy_definition.audit-dbmysql-cmk
}