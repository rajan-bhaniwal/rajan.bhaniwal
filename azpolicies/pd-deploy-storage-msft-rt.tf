resource "azurerm_policy_definition" "deploy-storage-msft-rt" {
  name         = "deploy-storage-msft-rt"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy Storage account routingPreference to Microsoft"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "20",
    "fim-12-ctrl": "",
    "priority": "P1",
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
                    "field":"Microsoft.Storage/storageAccounts/routingPreference",
                    "exists": false
                    }
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
          "value": "[field('Microsoft.Storage/storageAccounts/routingPreference.routingChoice')]",
          "equals": "MicrosoftRouting"
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
              }
            },
            "resources": [
              {
                "apiVersion": "2020-08-01-preview",
                "type": "Microsoft.Storage/storageAccounts",
                "name": "[concat(parameters('storageAccountName'))]",
                "location": "[concat(parameters('location'))]",
                "properties": {
                  "routingPreference": {
                      "routingChoice": "MicrosoftRouting",
                      "publishMicrosoftEndpoints": false,
                      "publishInternetEndpoints": false
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
            }
          }
        }
      }
    }
  }
}
POLICY_RULE
}

output "policydefinition_deploy-storage-msft-rt" {
  value = azurerm_policy_definition.deploy-storage-msft-rt
}