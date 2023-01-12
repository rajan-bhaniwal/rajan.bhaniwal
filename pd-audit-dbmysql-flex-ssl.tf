resource "azurerm_policy_definition" "audit-dbmysql-flex-ssl" {
  name                  = "audit-dbmysql-flex-ssl"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Azure MySQL flexible servers SSL connection should be enabled."
  description           = "This Policy Audits SSL enforcement of MySQL flexible Servers, Azure Database for MySQL flexible supports connecting your Azure Database for MySQL server to client applications using Secure Sockets Layer (SSL). Enforcing SSL connections between your database server and your client applications helps protect against 'man in the middle' attacks by encrypting the data stream between the server and your application. This configuration enforces that SSL is always enabled for accessing your database server."
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
            "equals": "Microsoft.DBforMySQL/flexibleServers"
          },
          {
            "field": "Microsoft.DBForMySql/flexibleServers/sslEnforcement",
            "exists": "true"
          },
          {
            "field": "Microsoft.DBForMySql/flexibleServers/sslEnforcement",
            "notEquals": "Enabled"
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

output "policydefinition_audit-dbmysql-flex-ssl" {
  value = azurerm_policy_definition.audit-dbmysql-flex-ssl
}