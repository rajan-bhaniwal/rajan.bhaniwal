resource "azurerm_policy_definition" "audit-storage-key-rotation" {
  name         = "audit-storage-key-rotation"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit - Storage account keys must be rotated every 90 days."
  description  = "Audit - Storage account keys must be rotated every 90 days for improving security of account keys. Set key rotation reminder to 90 days."



  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "Governance",
    "fim-12-ctrl": "Governance",
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
            "equals": "Microsoft.Storage/storageAccounts"
          },                
          {
            "anyOf": [
              {
                "value": "[utcNow()]",
                "greater": "[if(and(not(empty(coalesce(field('Microsoft.Storage/storageAccounts/keyCreationTime.key1'), ''))), not(empty(string(coalesce(field('Microsoft.Storage/storageAccounts/keyPolicy.keyExpirationPeriodInDays'), ''))))), addDays(field('Microsoft.Storage/storageAccounts/keyCreationTime.key1'), field('Microsoft.Storage/storageAccounts/keyPolicy.keyExpirationPeriodInDays')), utcNow())]"
              },
              {
                "value": "[utcNow()]",
                "greater": "[if(and(not(empty(coalesce(field('Microsoft.Storage/storageAccounts/keyCreationTime.key2'), ''))), not(empty(string(coalesce(field('Microsoft.Storage/storageAccounts/keyPolicy.keyExpirationPeriodInDays'), ''))))), addDays(field('Microsoft.Storage/storageAccounts/keyCreationTime.key2'), field('Microsoft.Storage/storageAccounts/keyPolicy.keyExpirationPeriodInDays')), utcNow())]"
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

  parameters  = <<PARAMETERS
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

output "policydefinition_audit-storage-key-rotation" {
  value = azurerm_policy_definition.audit-storage-key-rotation
}