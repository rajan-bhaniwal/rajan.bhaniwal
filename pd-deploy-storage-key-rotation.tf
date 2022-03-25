resource "azurerm_policy_definition" "deploy-storagekey-rotation" {
  name         = "deploy-storagekey-rotation"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy - Set a reminder to rotate storage account access keys."
  description  = "Deploy - Set a reminder to rotate storage account access keys. Enable key rotation reminders checkbox and set a frequency for the reminder"

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
            }
          ]
    },
  "then": {
    "effect": "DeployIfNotExists",
    "details": {
    "type": "Microsoft.Storage/storageAccounts",
    "roleDefinitionIds": [
      "/providers/Microsoft.Authorization/roleDefinitions/17d1049b-9a84-46fb-8f53-869881c3d3ab"
    ],
    "existenceCondition": {
        "allOf": [
          {
            "field":"Microsoft.Storage/storageAccounts/keyPolicy.keyExpirationPeriodInDays",
            "exists": "true"
          },
          {
            "field":"Microsoft.Storage/storageAccounts/keyPolicy.keyExpirationPeriodInDays",
            "equals": "[parameters('keyRotationInDays')]"
          }
        ]
      },
      "deployment": {
        "properties": {
          "mode": "incremental",
          "template": {
            "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "parameters": {
              "storageAccountName": {
                "type": "string"
              },
              "location": {
                "type": "string"
              },
              "keyRotationInDays": {
                "type": "int"
              }
            },
            "resources": [
              {
                "apiVersion": "2021-08-01",
                "type": "Microsoft.Storage/storageAccounts",
                "name": "[concat(parameters('storageAccountName'))]",
                "location": "[concat(parameters('location'))]",
                "properties": {
                  "keyPolicy": {
                    "keyExpirationPeriodInDays": "[parameters('keyRotationInDays')]"
                  }
                }
              }
            ]
          },
          "parameters": {
            "storageAccountName": {
              "value": "[field('name')]"
            },
            "location": {
              "value": "[field('location')]"
            },
            "keyRotationInDays": {
              "value": "[parameters('keyRotationInDays')]"
            } 
          }
        }
      }
    }
  }
}
POLICY_RULE
  parameters  = <<PARAMETERS
  {
    "keyRotationInDays": {
      "type": "Integer",
      "metadata": {
        "displayName": "Storage Key Rotation Policy in Days",
        "description": "Storage Key Rotation Policy in Days"
      },
      "defaultValue": 90
    }
  }
PARAMETERS
}

output "policydefinition_deploy-storagekey-rotation" {
  value = azurerm_policy_definition.deploy-storagekey-rotation
}