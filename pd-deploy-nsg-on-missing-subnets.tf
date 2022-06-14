resource "azurerm_policy_definition" "deploy-nsg-on-sbnet" {
  name         = "deploy-nsg-on-sbnet"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy and Assign a new NSG on sunbets without NSG assignment"
  description  = "Deploy and Assign a new NSG on sunbets without NSG assignment"
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
                    "equals": "Microsoft.Network/virtualNetworks/subnets"
                },
                {
                  "value": "[if(empty(field('Microsoft.Network/virtualNetworks/subnets/networkSecurityGroup.id')), bool('false'), bool('true')) ]",
                  "equals": false
                },
                {
                  "not": {
                    "anyOf": [
                      {
                        "equals": "GatewaySubnet",
                        "field": "name"
                      },
                      {
                        "equals": "AzureFirewallSubnet",
                        "field": "name"
                      },
                      {
                        "equals": "AzureFirewallManagementSubnet",
                        "field": "name"
                      },
                      {
                        "contains": "-pe-",
                        "field": "name"
                      },
                      {
                        "contains": "privateendpoint",
                        "field": "name"
                      }
                    ]
                  }
                }
            ]
    },
  "then": {
    "effect": "DeployIfNotExists",
    "details": {
    "type": "Microsoft.Network/virtualNetworks",
    "evaluationDelay": "PT60M",
    "roleDefinitionIds": [
      "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
    ],
    "existenceCondition": { 
        "value": "[if(empty(field('Microsoft.Network/virtualNetworks/subnets[*].networkSecurityGroup.id')), bool('false'), bool('true')) ]",
        "equals": true    
      },
      "deployment": {
        "properties": {
          "mode": "incremental",
          "template": {
            "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "parameters": {
              "subnetName": {
                "type": "string"
              },
              "location": {
                "type": "string"
              },
              "subnetID": {
                "type": "string"
              },
              "subscriptionID": {
                "type": "string"
              },
              "resourceGroupName": {
                "type": "string"
              }
            },
            "variables" : {
              "nsgName" : "[string(concat(parameters('subnetName'),'-nsg'))]",
              "vNetName": "[split(string(parameters('subnetID')), '/')[8]]"
             },
            "resources": [
              {
                "apiVersion": "2021-08-01",
                "type": "Microsoft.Network/networkSecurityGroups",
                "dependsOn": [
                ],
                "name": "[variables('nsgName')]",
                "location": "[resourceGroup().location]",
                "properties": {
                  "securityRules": [
                    {
                      "name": "deny-rule-inbound",
                      "properties": {
                        "description": "Deployed via policy - Deny-All",
                        "protocol": "*",
                        "sourcePortRange": "*",
                        "destinationPortRange": "*",
                        "sourceAddressPrefix": "*",
                        "destinationAddressPrefix": "*",
                        "access": "Deny",
                        "priority": 100,
                        "direction": "Inbound"
                      }
                    },
                    {
                      "name": "deny-rule-outbound",
                      "properties": {
                        "description": "Deployed via policy - Deny-All",
                        "protocol": "*",
                        "sourcePortRange": "*",
                        "destinationPortRange": "*",
                        "sourceAddressPrefix": "*",
                        "destinationAddressPrefix": "*",
                        "access": "Deny",
                        "priority": 100,
                        "direction": "Outbound"
                      }
                    }
                  ]
                }
              },
              {
                "apiVersion": "2017-08-01",
                "name": "[take(concat('apply-nsg-to-subnet', '_', variables('nsgName')), 50)]",
                "type": "Microsoft.Resources/deployments",
                "dependsOn": [
                  "[resourceId('Microsoft.Network/networkSecurityGroups', variables('nsgName'))]"
                ],
                "properties": {
                  "mode" : "Incremental",
                  "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "resources": [
                      {
                        "apiVersion": "2021-08-01",
                        "type": "Microsoft.Network/virtualNetworks/subnets",
                        "dependsOn": [
                        ],
                        "name": "[concat(variables('vNetName'), '/', parameters('subnetName'))]",
                        "location": "[resourceGroup().location]",
                        "properties": {
                          "addressPrefix": "[reference(parameters('subnetID'), '2021-08-01').addressPrefix]",
                          "networkSecurityGroup": {
                            "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('nsgName'))]"
                          }
                        }
                      }
                    ]
                  }
                }
              }
            ],
            "outputs": {
              "nsgName": {
                "type": "string",
                "value": "[concat('nsgName', ': ', variables('nsgName'))]"
              },
              "vNetName": {
                "type": "string",
                "value": "[variables('vNetName')]"
              },
              "subnetID": {
                "type": "string",
                "value": "[parameters('subnetID')]"
              }
            }
          },
          "parameters": {
            "subnetName": {
              "value": "[field('name')]"
            },
            "subnetID": {
              "value": "[field('id')]"
            },
            "location": {
              "value": "[field('location')]"
            },
            "subscriptionID": {
              "value":  "[subscription().id]"
            },
            "resourceGroupName": {
              "value":  "[resourceGroup().name]"
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
  }
PARAMETERS
}

output "policydefinition_deploy-nsg-on-sbnet" {
  value = azurerm_policy_definition.deploy-nsg-on-sbnet
}