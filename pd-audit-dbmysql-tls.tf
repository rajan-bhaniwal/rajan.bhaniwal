resource "azurerm_policy_definition" "audit-dbmysql-tls" {
  name                  = "audit-dbmysql-tls"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Azure MySQL servers required minimum version for TLS must be set to 1.2"
  description           = "This policy audits MySQL servers required minimum version for TLS must be set to 1.2 or higher. https://docs.microsoft.com/en-us/azure/event-hubs/transport-layer-security-configure-minimum-version"
  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-DBSQL-CTRL-12",
    "fim-l2-ctrl": "DSEC.4, DSEC.5",
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
          },
          {
            "field": "Microsoft.DBforMySQL/servers/minimalTlsVersion",
            "notEquals": "TLS1_2"
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

output "policydefinition_audit-dbmysql-tls" {
  value = azurerm_policy_definition.audit-dbmysql-tls
}