resource "azurerm_policy_definition" "audit-kv-st-acl-ips" {
  name         = "audit-kv-st-acl-ips"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Services must not have unapproved public IPs in allowed firewall access list."
  description  = "Azure Services must not have unapproved public IPs in allowed firewall access list."



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
              "anyOf": [
                  {
                    "allOf": [
                        {
                          "field": "[concat(parameters('azureServiceType'), '/networkAcls.ipRules[*].value')]",
                          "notEquals": ""
                        },
                        {
                          "not": {
                              "field": "[concat(parameters('azureServiceType'), '/networkAcls.ipRules[*].value')]",
                              "in": "[parameters('allowedAddressRanges')]"
                          }
                        }
                    ]
                  },
                  {
                    "field": "[concat(parameters('azureServiceType'), '/networkAcls.defaultAction')]",
                    "equals": "Allow"
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
      "defaultValue": "Deny"
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
      "allowedValues": [
        "Microsoft.Storage/storageAccounts",
        "Microsoft.KeyVault/vaults"
      ],      
      "defaultValue": "Microsoft.Storage/storageAccounts"
    }         
  }
PARAMETERS
}

output "policydefinition_audit-kv-st-acl-ips" {
  value = azurerm_policy_definition.audit-kv-st-acl-ips
}