resource "azurerm_policy_definition" "deploy-blob-priv-dnsconf" {
  name                  = "deploy-blob-priv-dnsconf"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Azure Private Endpoint DNS (privatelink.blob.core.windows.net) configuration for Blob storage."
  description           = "This policy deployes privateDNSZoneGroup configuration for blob storage private endpoint, which associates the private endpoint with the private DNS zone (privatelink.blob.core.windows.net) hosted in central HUB"
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
            "equals": "Microsoft.Network/privateEndpoints"
          },
          {
            "count": {
              "field": "Microsoft.Network/privateEndpoints/privateLinkServiceConnections[*].groupIds[*]",
              "where": {
                "field": "Microsoft.Network/privateEndpoints/privateLinkServiceConnections[*].groupIds[*]",
                "equals": "blob"
              }
            },
            "greaterOrEquals": 1
          }
        ]
    },
  "then": {
    "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.Network/privateEndpoints/privateDnsZoneGroups",
          "roleDefinitionIds": [
            "/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7"
          ],
          "existenceCondition": {
            "count": {
              "field": "Microsoft.Network/privateEndpoints/privateDnsZoneGroups/privateDnsZoneConfigs[*]",
              "where": {
                "field": "Microsoft.Network/privateEndpoints/privateDnsZoneGroups/privateDnsZoneConfigs[*].privateDnsZoneId",
                "equals": "[parameters('privateDnsZoneId')]"
              }
            },
            "greaterOrEquals": 1
          },
          "deployment": {
            "properties": {
              "mode": "incremental",
              "template": {
                "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": {
                  "privateDnsZoneId": {
                    "type": "string"
                  },
                  "privateDnsZoneGroupName": {
                    "type": "string"
                  },
                  "privateEndpointName": {
                    "type": "string"
                  },
                  "location": {
                    "type": "string"
                  }
                },
                "resources": [
                  {
                    "name": "[concat(parameters('privateEndpointName'), '/', parameters('privateDnsZoneGroupName'))]",
                    "type": "Microsoft.Network/privateEndpoints/privateDnsZoneGroups",
                    "apiVersion": "2020-03-01",
                    "location": "[parameters('location')]",
                    "properties": {
                      "privateDnsZoneConfigs": [
                        {
                          "name": "storageBlob-privateDnsZone",
                          "properties": {
                            "privateDnsZoneId": "[parameters('privateDnsZoneId')]"
                          }
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters": {
                "privateDnsZoneId": {
                  "value": "[parameters('privateDnsZoneId')]"
                },
                "privateDnsZoneGroupName": {
                  "value": "[parameters('privateDnsZoneGroupName')]"
                },
                "privateEndpointName": {
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
  parameters  = <<PARAMETERS
  {
      "effect": {
        "type": "String",
        "metadata": {
          "displayName": "Effect",
          "description": "Enable or disable the execution of the policy"
        },
        "allowedValues": [
          "DeployIfNotExists",
          "Disabled"
        ],
        "defaultValue": "DeployIfNotExists"
      },
      "privateDnsZoneId": {
        "type": "String",
        "metadata": {
          "displayName": "privateDnsZoneId",
          "description": "Resource ID of Private Link DNS Zone hosted in central HUB",
          "strongType": "Microsoft.Network/privateDnsZones"
        }
      },
      "privateDnsZoneGroupName": {
        "type": "String",
        "metadata": {
          "displayName": "Pivate Dns Zone Group Name, i.e 'default'",
          "description": "Pivate Dns Zone Group Name, Adding multiple DNS zone groups to a single Private Endpoint is not supported."
        },
        "defaultValue": "default"
      }
  }
PARAMETERS
}

output "policydefinition_deploy-blob-priv-dnsconf" {
  value = azurerm_policy_definition.deploy-blob-priv-dnsconf
}