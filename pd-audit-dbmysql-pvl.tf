resource "azurerm_policy_definition" "audit-dbmysql-pvl" {
  name         = "audit-dbmysql-pvl"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure MySQL Servers should use private link"
  description  = "Azure MySQL Servers should use private link. Azure Private Link lets you connect your virtual network to Azure services without a public IP address at the source or destination. The Private Link platform handles the connectivity between the consumer and services over the Azure backbone network. By mapping private endpoints to your BotService resource, data leakage risks are reduced."

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-DBSQL-CTRL-08",
    "fim-l2-ctrl": "DSEC.2, DMAN.3",
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
        "type": "Microsoft.DBforMySQL/servers/privateEndpointConnections",
        "existenceCondition": {
          "field": "Microsoft.DBforMySQL/servers/privateEndpointConnections/privateLinkServiceConnectionState.status",
          "equals": "Approved"
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

output "policydefinition_audit-dbmysql-pvl" {
  value = azurerm_policy_definition.audit-dbmysql-pvl
}