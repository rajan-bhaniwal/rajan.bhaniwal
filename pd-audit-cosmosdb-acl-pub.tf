resource "azurerm_policy_definition" "audit-cosmosdb-acl-ips" {
  name         = "audit-cosmosdb-acl-ips"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure CosmosDB must not have unapproved public IPs in allowed firewall access list."
  description  = "Azure CosmosDB must not have unapproved public IPs in allowed firewall access list."



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
              "not": {
                  "field": "[concat(parameters('azureServiceType'), '/ipRules[*].ipAddressOrRange')]",
                  "in": "[parameters('allowedAddressRanges')]"
              }
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
      "defaultValue": "Deny"
    },
    "allowedAddressRanges": {
      "type": "Array",
      "metadata": {
          "displayName": "Allowed Address Ranges",
          "description": "The list of IP Addresses or IP Address Ranges that are allowed for the Firewall Setting on the Storage Account"
      },
      "defaultValue": [
        "104.42.195.92",
        "40.76.54.131",
        "52.176.6.30",
        "52.169.50.45",
        "52.187.184.26"
        ]
    },
    "azureServiceType": {
      "type": "String",
      "metadata": {
          "displayName": "Azure Service Type to Audit",
          "description": "The list of Azure Service Type to Audit"
      },
      "allowedValues": [
        "Microsoft.DocumentDB/databaseAccounts"
      ],      
      "defaultValue": "Microsoft.DocumentDB/databaseAccounts"
    }         
  }
PARAMETERS
}

output "policydefinition_audit-cosmosdb-acl-ips" {
  value = azurerm_policy_definition.audit-cosmosdb-acl-ips
}