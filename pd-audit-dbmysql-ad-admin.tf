resource "azurerm_policy_definition" "audit-dbmysql-ad-admin" {
  name         = "audit-dbmysql-ad-admin"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure MySQL servers An Azure Active Directory administrator must be provisioned for Azure AD authentication."
  description  = "This policy audits Azure MySQL servers for Active Directory administrator must be provisioned for Azure AD authentication.Azure AD authentication enables simplified permission management and centralized identity management of database users and other Microsoft services."

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-DBSQL-CTRL-06",
    "fim-l2-ctrl": "IDAM.3, IDAM.5",
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
          "type": "Microsoft.DBforMySQL/servers/administrators",
          "existenceCondition": {
            "allOf": [
              {
                "field": "Microsoft.DBforMySQL/servers/administrators/activeDirectory.administratorType",
                "equals": "ActiveDirectory"
              },
              {
                "field": "Microsoft.DBforMySQL/servers/administrators/activeDirectory.administratorType",
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

output "policydefinition_audit-dbmysql-ad-admin" {
  value = azurerm_policy_definition.audit-dbmysql-ad-admin
}