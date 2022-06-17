resource "azurerm_policy_definition" "deploy-aks-policy-addon" {
  name         = "deploy-aks-policy-addon"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy Azure Policy Add-on to Azure Kubernetes Service clusters"
  description  = "Use Azure Policy Add-on to manage and report on the compliance state of your Azure Kubernetes Service (AKS) clusters. For more information, see https://aka.ms/akspolicydoc."
  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-AKS-CTRL-52",
    "fim-12-ctrl": "SECA.1",
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
                  "equals": "Microsoft.ContainerService/managedClusters"
                }
            ]
    },
  "then": {
    "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.ContainerService/managedClusters",
          "name": "[field('name')]",
          "evaluationDelay": "PT30M",
          "roleDefinitionIds": [
            "/providers/Microsoft.Authorization/roleDefinitions/ed7f3fbd-7b88-4dd4-9017-9adb7ce333f8",
            "/providers/Microsoft.Authorization/roleDefinitions/18ed5180-3e48-46fd-8541-4ea054d57064"
          ],
          "existenceCondition": {
            "field": "Microsoft.ContainerService/managedClusters/addonProfiles.azurePolicy.enabled",
            "equals": "true"
          },
          "deployment": {
            "properties": {
              "mode": "incremental",
              "template": {
                "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": {
                  "clusterName": {
                    "type": "string"
                  },
                  "clusterResourceGroupName": {
                    "type": "string"
                  }
                },
                "variables": {
                  "clusterGetDeploymentName": "[concat('PolicyDeployment-Get-', parameters('clusterName'))]",
                  "clusterUpdateDeploymentName": "[concat('PolicyDeployment-Update-', parameters('clusterName'))]"
                },
                "resources": [
                  {
                    "apiVersion": "2020-06-01",
                    "type": "Microsoft.Resources/deployments",
                    "name": "[variables('clusterGetDeploymentName')]",
                    "properties": {
                      "mode": "Incremental",
                      "template": {
                        "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                        "contentVersion": "1.0.0.0",
                        "resources": [],
                        "outputs": {
                          "aksCluster": {
                            "type": "object",
                            "value": "[reference(resourceId(parameters('clusterResourceGroupName'), 'Microsoft.ContainerService/managedClusters', parameters('clusterName')), '2021-07-01', 'Full')]"
                          }
                        }
                      }
                    }
                  },
                  {
                    "apiVersion": "2020-06-01",
                    "type": "Microsoft.Resources/deployments",
                    "name": "[variables('clusterUpdateDeploymentName')]",
                    "properties": {
                      "mode": "Incremental",
                      "expressionEvaluationOptions": {
                        "scope": "inner"
                      },
                      "template": {
                        "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                        "contentVersion": "1.0.0.0",
                        "parameters": {
                          "aksClusterName": {
                            "type": "string"
                          },
                          "aksClusterContent": {
                            "type": "object"
                          }
                        },
                        "resources": [
                          {
                            "apiVersion": "2021-07-01",
                            "type": "Microsoft.ContainerService/managedClusters",
                            "name": "[parameters('aksClusterName')]",
                            "location": "[parameters('aksClusterContent').location]",
                            "sku": "[parameters('aksClusterContent').sku]",
                            "tags": "[if(contains(parameters('aksClusterContent'), 'tags'), parameters('aksClusterContent').tags, json('null'))]",
                            "properties": {
                              "kubernetesVersion": "[parameters('aksClusterContent').properties.kubernetesVersion]",
                              "dnsPrefix": "[parameters('aksClusterContent').properties.dnsPrefix]",
                              "agentPoolProfiles": "[if(contains(parameters('aksClusterContent').properties, 'agentPoolProfiles'), parameters('aksClusterContent').properties.agentPoolProfiles, json('null'))]",
                              "linuxProfile": "[if(contains(parameters('aksClusterContent').properties, 'linuxProfile'), parameters('aksClusterContent').properties.linuxProfile, json('null'))]",
                              "windowsProfile": "[if(contains(parameters('aksClusterContent').properties, 'windowsProfile'), parameters('aksClusterContent').properties.windowsProfile, json('null'))]",
                              "servicePrincipalProfile": "[if(contains(parameters('aksClusterContent').properties, 'servicePrincipalProfile'), parameters('aksClusterContent').properties.servicePrincipalProfile, json('null'))]",
                              "addonProfiles": {
                                "azurepolicy": {
                                  "enabled": true
                                }
                              },
                              "nodeResourceGroup": "[parameters('aksClusterContent').properties.nodeResourceGroup]",
                              "enableRBAC": "[if(contains(parameters('aksClusterContent').properties, 'enableRBAC'), parameters('aksClusterContent').properties.enableRBAC, json('null'))]",
                              "enablePodSecurityPolicy": "[if(contains(parameters('aksClusterContent').properties, 'enablePodSecurityPolicy'), parameters('aksClusterContent').properties.enablePodSecurityPolicy, json('null'))]",
                              "networkProfile": "[if(contains(parameters('aksClusterContent').properties, 'networkProfile'), parameters('aksClusterContent').properties.networkProfile, json('null'))]",
                              "aadProfile": "[if(contains(parameters('aksClusterContent').properties, 'aadProfile'), parameters('aksClusterContent').properties.aadProfile, json('null'))]",
                              "autoScalerProfile": "[if(contains(parameters('aksClusterContent').properties, 'autoScalerProfile'), parameters('aksClusterContent').properties.autoScalerProfile, json('null'))]",
                              "apiServerAccessProfile": "[if(contains(parameters('aksClusterContent').properties, 'apiServerAccessProfile'), parameters('aksClusterContent').properties.apiServerAccessProfile, json('null'))]",
                              "diskEncryptionSetID": "[if(contains(parameters('aksClusterContent').properties, 'diskEncryptionSetID'), parameters('aksClusterContent').properties.diskEncryptionSetID, json('null'))]",
                              "identityProfile": "[if(contains(parameters('aksClusterContent').properties, 'identityProfile'), parameters('aksClusterContent').properties.identityProfile, json('null'))]"
                            }
                          }
                        ],
                        "outputs": {}
                      },
                      "parameters": {
                        "aksClusterName": {
                          "value": "[parameters('clusterName')]"
                        },
                        "aksClusterContent": {
                          "value": "[reference(variables('clusterGetDeploymentName')).outputs.aksCluster.value]"
                        }
                      }
                    }
                  }
                ]
              },
              "parameters": {
                "clusterName": {
                  "value": "[field('name')]"
                },
                "clusterResourceGroupName": {
                  "value": "[resourceGroup().name]"
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
      }    
  }
PARAMETERS
}

output "policydefinition_deploy-aks-policy-addon" {
  value = azurerm_policy_definition.deploy-aks-policy-addon
}