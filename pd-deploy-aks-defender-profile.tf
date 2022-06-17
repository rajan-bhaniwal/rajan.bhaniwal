resource "azurerm_policy_definition" "deploy-aks-defender-profile" {
  name         = "deploy-aks-defender-profile"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Configure Azure Kubernetes Service clusters to enable Defender profile"
  description  = "Microsoft Defender for Containers provides cloud-native Kubernetes security capabilities including environment hardening, workload protection, and run-time protection. When you enable the SecurityProfile.AzureDefender on your Azure Kubernetes Service cluster, an agent is deployed to your cluster to collect security event data. Learn more about Microsoft Defender for Containers: https://docs.microsoft.com/azure/defender-for-cloud/defender-for-containers-introduction?tabs=defender-for-container-arch-aks."
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
          "deploymentScope": "subscription",
          "name": "[field('name')]",
          "evaluationDelay": "PT30M",
          "existenceCondition": {
            "field": "Microsoft.ContainerService/managedClusters/securityProfile.azureDefender.enabled",
            "equals": "true"
          },
          "roleDefinitionIds": [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c",
            "/providers/microsoft.authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293"
          ],
          "deployment": {
            "location": "westeurope",
            "properties": {
              "mode": "incremental",
              "parameters": {
                "clusterRegion": {
                  "value": "[field('location')]"
                },
                "clusterResourceId": {
                  "value": "[field('id')]"
                },
                "clusterName": {
                  "value": "[field('name')]"
                },
                "logAnalyticsWorkspaceResourceId": {
                  "value": "[parameters('logAnalyticsWorkspaceResourceId')]"
                }
              },
              "template": {
                "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": {
                  "clusterRegion": {
                    "type": "string"
                  },
                  "clusterResourceId": {
                    "type": "string"
                  },
                  "clusterName": {
                    "type": "string"
                  },
                  "logAnalyticsWorkspaceResourceId": {
                    "type": "string"
                  }
                },
                "variables": {
                  "locationLongNameToShortMap": {
                    "australiacentral": "CAU",
                    "australiacentral2": "CBR2",
                    "australiaeast": "EAU",
                    "australiasoutheast": "SEAU",
                    "brazilsouth": "CQ",
                    "brazilsoutheast": "BRSE",
                    "canadacentral": "CCA",
                    "canadaeast": "YQ",
                    "centralindia": "CIN",
                    "centralus": "CUS",
                    "eastasia": "EA",
                    "eastus": "EUS",
                    "eastus2": "EUS2",
                    "eastus2euap": "eus2p",
                    "germanywestcentral": "DEWC",
                    "francecentral": "PAR",
                    "francesouth": "MRS",
                    "japaneast": "EJP",
                    "japanwest": "OS",
                    "jioindiacentral": "JINC",
                    "jioindiawest": "JINW",
                    "koreacentral": "SE",
                    "koreasouth": "PS",
                    "northcentralus": "NCUS",
                    "northeurope": "NEU",
                    "norwayeast": "NOE",
                    "norwaywest": "NOW",
                    "southafricanorth": "JNB",
                    "southcentralus": "SCUS",
                    "southeastasia": "SEA",
                    "southindia": "MA",
                    "swedencentral": "SEC",
                    "switzerlandnorth": "CHN",
                    "switzerlandwest": "CHW",
                    "uaecentral": "AUH",
                    "uaenorth": "DXB",
                    "uksouth": "SUK",
                    "ukwest": "WUK",
                    "westcentralus": "WCUS",
                    "westeurope": "WEU",
                    "westus": "WUS",
                    "westus2": "WUS2",
                    "westus3": "USW3"
                  },
                  "locationCode": "[variables('locationLongNameToShortMap')[parameters('clusterRegion')]]",
                  "subscriptionId": "[subscription().subscriptionId]",
                  "shouldProvisionDefaultWorkspace": "[empty(parameters('logAnalyticsWorkspaceResourceId'))]",
                  "defaultRGName": "[concat('DefaultResourceGroup-', variables('locationCode'))]",
                  "workspaceName": "[concat('DefaultWorkspace-', variables('subscriptionId'),'-', variables('locationCode'))]",
                  "deployDefaultAscResourceGroup": "[concat('deployDefaultAscResourceGroup-', uniqueString(deployment().name))]",
                  "getResourceDeploymentName": "[concat('getExistingCluster-', uniqueString(deployment().name))]"
                },
                "resources": [
                  {
                    "condition": "[variables('shouldProvisionDefaultWorkspace')]",
                    "type": "Microsoft.Resources/resourceGroups",
                    "name": "[variables('defaultRGName')]",
                    "apiVersion": "2019-05-01",
                    "location": "[parameters('clusterRegion')]"
                  },
                  {
                    "condition": "[variables('shouldProvisionDefaultWorkspace')]",
                    "type": "Microsoft.Resources/deployments",
                    "name": "[variables('deployDefaultAscResourceGroup')]",
                    "apiVersion": "2020-06-01",
                    "resourceGroup": "[variables('defaultRGName')]",
                    "properties": {
                      "mode": "Incremental",
                      "expressionEvaluationOptions": {
                        "scope": "inner"
                      },
                      "parameters": {
                        "clusterRegion": {
                          "value": "[parameters('clusterRegion')]"
                        },
                        "workspaceName": {
                          "value": "[variables('workspaceName')]"
                        }
                      },
                      "template": {
                        "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
                        "contentVersion": "1.0.0.0",
                        "parameters": {
                          "clusterRegion": {
                            "type": "string"
                          },
                          "workspaceName": {
                            "type": "string"
                          }
                        },
                        "variables": {},
                        "resources": [
                          {
                            "type": "Microsoft.OperationalInsights/workspaces",
                            "name": "[parameters('workspaceName')]",
                            "apiVersion": "2021-06-01",
                            "location": "[parameters('clusterRegion')]",
                            "properties": {
                              "sku": {
                                "name": "pernode"
                              },
                              "retentionInDays": 30,
                              "features": {
                                "searchVersion": 1
                              }
                            }
                          }
                        ]
                      }
                    },
                    "dependsOn": [
                      "[resourceId('Microsoft.Resources/resourceGroups', variables('defaultRGName'))]"
                    ]
                  },
                  {
                    "type": "Microsoft.Resources/deployments",
                    "apiVersion": "2020-06-01",
                    "name": "[variables('getResourceDeploymentName')]",
                    "location": "[parameters('clusterRegion')]",
                    "properties": {
                      "mode": "Incremental",
                      "parameters": {
                        "clusterResourceId": {
                          "value": "[parameters('clusterResourceId')]"
                        },
                        "clusterName": {
                          "value": "[parameters('clusterName')]"
                        }
                      },
                      "template": {
                        "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                        "contentVersion": "1.0.0.0",
                        "parameters": {
                          "clusterResourceId": {
                            "type": "string"
                          },
                          "clusterName": {
                            "type": "string"
                          }
                        },
                        "resources": [],
                        "outputs": {
                          "existingCluster": {
                            "type": "object",
                            "value": "[reference(resourceId(variables('subscriptionId'), split(parameters('clusterResourceId'),'/')[4], 'Microsoft.ContainerService/managedClusters', parameters('clusterName')), '2022-02-01', 'Full')]"
                          }
                        }
                      }
                    }
                  },
                  {
                    "type": "Microsoft.Resources/deployments",
                    "name": "[concat('securityprofile-deploy-', uniqueString(parameters('clusterResourceId')))]",
                    "apiVersion": "2020-10-01",
                    "subscriptionId": "[variables('subscriptionId')]",
                    "resourceGroup": "[split(parameters('clusterResourceId'),'/')[4]]",
                    "properties": {
                      "mode": "Incremental",
                      "expressionEvaluationOptions": {
                        "scope": "inner"
                      },
                      "parameters": {
                        "workspaceResourceId": {
                          "value": "[if(variables('shouldProvisionDefaultWorkspace'), concat('/subscriptions/', variables('subscriptionId'), '/resourcegroups/', variables('defaultRGName'), '/providers/Microsoft.OperationalInsights/workspaces/', variables('workspaceName')), parameters('logAnalyticsWorkspaceResourceId'))]"
                        },
                        "clusterName": {
                          "value": "[parameters('clusterName')]"
                        },
                        "clusterRegion": {
                          "value": "[parameters('clusterRegion')]"
                        },
                        "aksClusterContent": {
                          "value": "[reference(variables('getResourceDeploymentName')).outputs.existingCluster.value]"
                        }
                      },
                      "template": {
                        "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
                        "contentVersion": "1.0.0.0",
                        "parameters": {
                          "workspaceResourceId": {
                            "type": "string"
                          },
                          "clusterName": {
                            "type": "string"
                          },
                          "clusterRegion": {
                            "type": "string"
                          },
                          "aksClusterContent": {
                            "type": "object"
                          }
                        },
                        "resources": [
                          {
                            "type": "Microsoft.ContainerService/ManagedClusters",
                            "name": "[parameters('clusterName')]",
                            "apiVersion": "2022-02-01",
                            "location": "[parameters('clusterRegion')]",
                            "properties": {
                              "securityProfile": {
                                "azureDefender": {
                                  "enabled": true,
                                  "logAnalyticsWorkspaceResourceId": "[parameters('workspaceResourceId')]"
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
                        ]
                      }
                    },
                    "dependsOn": [
                      "[variables('deployDefaultAscResourceGroup')]"
                    ]
                  }
                ]
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
      "logAnalyticsWorkspaceResourceId": {
        "type": "String",
        "metadata": {
          "displayName": "LogAnalyticsWorkspaceResourceId",
          "description": "Optional Log Analytics workspace resource id. If provided, will be used as part of the feature configuration. Otherwise, default workspace will be provisioned. Value format should be '/subscriptions/XXX/resourcegroups/XXX/providers/Microsoft.OperationalInsights/workspaces/XXX'.",
          "strongType": "Microsoft.OperationalInsights/workspaces",
          "assignPermissions": true
        },
        "defaultValue": ""
      }    
  }
PARAMETERS
}

output "policydefinition_deploy-aks-defender-profile" {
  value = azurerm_policy_definition.deploy-aks-defender-profile
}