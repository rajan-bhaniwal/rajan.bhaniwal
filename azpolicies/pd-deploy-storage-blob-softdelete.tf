resource "azurerm_policy_definition" "deploy-storage-blob-softdelete" {
  name         = "deploy-storage-blob-softdelete"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Enable Storage Blob Should be configured with softdelete"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "43 & 59",
    "fim-12-ctrl": "",
    "priority": "P2",
    "source" : "",
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
        "not": {
                 "field":"Microsoft.Storage/storageAccounts/isHnsEnabled",
                 "equals": true
                }
        }
      ]
    },
      "then": {
        "effect": "DeployIfNotExists",
        "details": {
          "type": "Microsoft.Storage/storageAccounts/blobServices",
          "name": "default",
          "existenceCondition": {
            "allOf": [
            {
              "field":"Microsoft.Storage/storageAccounts/blobServices/default.deleteRetentionPolicy.enabled",
              "equals": "true"
            }
            ]
          },
          "roleDefinitionIds": [
            "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "deployment": {
            "properties": {
              "mode": "incremental",
              "template": {
                "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": {
                  "storageAccountName": {
                    "type": "string"
                  }
                },
                "resources": [
                  {
                    "apiVersion": "2020-08-01-preview",
                    "type": "Microsoft.Storage/storageAccounts/blobServices",
                    "name": "[concat(parameters('storageAccountName'), '/default')]",
                    "properties": {
                      "deleteRetentionPolicy": {
                          "enabled": true,
                          "days": 14
                      }
                    }
                  }
                ]
              },
              "parameters": {
                "storageAccountName": {
                  "value": "[field('name')]"
                }
              }
            }
          }
        }
      }
  }
POLICY_RULE
}

output "policydefinition_deploy-storage-blob-softdelete" {
  value = azurerm_policy_definition.deploy-storage-blob-softdelete
}