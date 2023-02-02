resource "azurerm_policy_definition" "audit-sqldb-acl-ips" {
  name         = "audit-sqldb-acl-ips"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "SQL Database Server must not have unapproved public IPs in allowed firewall access list."
  description  = "SQL Database Server must not have unapproved public IPs in allowed firewall access list."



  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "Governance",
    "fim-l2-ctrl": "Governance",
    "priority": "P2",
    "source" : "Governance",
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
              "equals": "[parameters('azureServiceType')]"
            },
            {
              "field": "[concat(parameters('azureServiceType'), '/publicNetworkAccess')]",
              "equals": "Enabled"
            }
        ]
      },
    "then": {
      "effect": "[parameters('effect')]",
        "details": {
          "type": "[concat(parameters('azureServiceType'), '/firewallRules')]",
          "existenceCondition": {
              "anyOf": [
                  {
                    "allOf": [
                        {
                              "field": "[concat(parameters('azureServiceType'), '/firewallRules/endIpAddress')]",
                              "in": "[parameters('allowedAddressRanges')]"
                        },
                        {
                              "field": "[concat(parameters('azureServiceType'), '/firewallRules/startIpAddress')]",
                              "in": "[parameters('allowedAddressRanges')]"
                        }
                    ]
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
      },
    "allowedAddressRanges": {
      "type": "Array",
      "metadata": {
          "displayName": "Allowed Address Ranges",
          "description": "The list of IP Addresses or IP Address Ranges that are allowed for the Firewall Setting on the Storage Account"
      },
      "defaultValue": ["90.90.90.90", "8.8.8.8","90.90.90.90/32", "8.8.8.8/32"]
    },
    "azureServiceType": {
      "type": "String",
      "metadata": {
          "displayName": "Azure Service Type to Audit",
          "description": "The list of Azure Service Type to Audit"
      },
          "Microsoft.Sql/servers",
          "Microsoft.DBforMySQL/servers",
          "Microsoft.DBforMySQL/flexibleServers"
          "Microsoft.DBforPostgreSQL/servers",
          "Microsoft.DBForPostgreSql/flexibleServers"
        ],      
      "defaultValue": "Microsoft.Sql/servers"
    }         
  }
PARAMETERS
}

output "policydefinition_audit-sqldb-acl-ips" {
  value = azurerm_policy_definition.audit-sqldb-acl-ips
}