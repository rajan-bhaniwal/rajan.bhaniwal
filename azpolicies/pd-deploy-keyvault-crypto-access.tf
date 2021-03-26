resource "azurerm_policy_definition" "deploy-keyvault-crypto-access" {
  name         = "deploy-keyvault-crypto-access"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy Keyvault must have crypto team groups assigned in access policy"
  description  = "Deploy Keyvault must have crypto team groups assigned in access policy"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-KV-CTRL-17,19,20",
    "fim-12-ctrl": "",
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
                "equals": "Microsoft.KeyVault/vaults"
            }
          ]
      },
    "then": {
        "effect": "DeployIfNotExists",
        "details": {
            "type": "Microsoft.KeyVault/vaults",
            "roleDefinitionIds": [
                "/providers/Microsoft.Authorization/roleDefinitions/f25e0fa2-a7c8-4377-a976-54943a77a395"
            ],
            "existenceCondition": {
                "allOf": [
                    {
                        "count": {
                        "field": "Microsoft.Keyvault/vaults/accessPolicies[*]",
                            "where": {
                                "field": "Microsoft.Keyvault/vaults/accessPolicies[*].objectId",
                                "equals": "[parameters('ObjectId')]"
                            }
                        },
                        "equals": 1
                    }
                ]
            },
            "deployment": {
                "properties": {
                    "mode": "incremental",
                    "template": {
                        "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                        "contentVersion": "1.0.0.0",
                        "parameters": {
                            "keyvaultName": {
                                "type": "string"
                            },
                            "objectId": {
                                "type": "string"
                            },
                            "location": {
                                "type": "string"
                            },
                            "sku": {
                                "type": "object"
                            },
                            "tenantId": {
                                "type": "string"
                            },
                            "keysPermissions": {
                                "type": "array",
                                "defaultValue": [
                                        "list"
                                ]
                            },
                            "secretsPermissions": {
                                "type": "array",
                                "defaultValue": [
                                        "list"
                                ]
                            },
                            "certificatePermissions": {
                                "type": "array",
                                "defaultValue": [
                                    "list"
                                ]
                            },
                            "existingAccessPolicies": {
                                "type": "array",
                                "defaultValue": []
                            }
                        },
                        "variables": {
                            "accessPolicies": [
                            {
                                "tenantId": "[parameters('tenantId')]",
                                "objectId": "[parameters('objectId')]",
                                "permissions": {
                                    "keys": "[parameters('keysPermissions')]",
                                    "secrets": "[parameters('secretsPermissions')]",
                                    "certificates": "[parameters('certificatePermissions')]"
                                }
                            }
                          ]
                        },
                        "resources": [
                            {
                                "type": "Microsoft.KeyVault/vaults",
                                "apiVersion": "2018-02-14",
                                "name": "[parameters('keyVaultName')]",
                                "location": "[parameters('location')]",
                                "properties": {
                                    "tenantId": "[parameters('tenantId')]",
                                    "enableSoftDelete": true,
                                    "enablePurgeProtection": true,
                                    "sku": "[parameters('sku')]",
                                    "accessPolicies": "[concat(parameters('existingAccessPolicies'), variables('accessPolicies'))]"
                                }
                            }
                        ]
                    },
                    "parameters": {
                        "keyvaultName": {
                            "value": "[field('name')]"
                        },
                        "ObjectId": {
                            "value": "[parameters('objectId')]"
                        },
                        "location": {
                            "value": "[field('location')]"
                        },
                        "sku": {
                            "value": "[field('Microsoft.KeyVault/vaults/sku')]"
                        },
                        "tenantId": {
                            "value": "[field('Microsoft.KeyVault/vaults/tenantId')]"
                        },
                        "existingAccessPolicies": {
                            "value": "[field('Microsoft.Keyvault/vaults/accessPolicies')]"
                        },
                        "keysPermissions": {
                        "value": [
                            "encrypt", 
                            "decrypt", 
                            "wrapKey", 
                            "unwrapKey", 
                            "sign", 
                            "verify", 
                            "get", 
                            "list", 
                            "create", 
                            "update", 
                            "import", 
                            "delete", 
                            "backup", 
                            "restore", 
                            "recover",
                            "purge"
                            ]
                        },
                        "secretsPermissions": {
                        "value": [
                            "get", 
                            "list", 
                            "set", 
                            "delete", 
                            "backup", 
                            "restore", 
                            "recover",
                            "purge"
                            ]
                        },
                        "certificatePermissions": {
                        "value": ["all"]
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
    "ObjectId": {
    "type": "String",
    "metadata": {
        "displayName": "Provide Azure AD ObjectId (not application id) for Crypto keyvault AD group",
        "decription": "Provide Azure AD ObjectId (not application id) for Crypto keyvault AD group"
      },
    "defaultValue": ""
    }
  }
PARAMETERS

}


output "policydefinition_deploy-keyvault-crypto-access" {
  value = azurerm_policy_definition.deploy-keyvault-crypto-access
}