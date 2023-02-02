resource "azurerm_policy_definition" "deploy-mde-agentless-scan" {
  name         = "deploy-mde-agentless-scan"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Enable Defender for Cloud agentless scanning for machines"
  description  = "Enable Defender for Cloud agentless scanning for machines"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-VMLP-CTRL-14,16|AZR-VMLC-CTRL-11",
    "fim-l2-ctrl": "SDLC1, SECA.1,PROT.2,ITAM.4,ITOP2,VULN.1",
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
              "equals": "Microsoft.Resources/subscriptions"
            }
        ]
    },
      "then": {
        "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.Security/vmScanners",
          "deploymentScope": "subscription",
          "existenceScope": "subscription",
          "existenceCondition": {
            "field": "name",
            "equals": "default"
          },
          "roleDefinitionIds": [
            "/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168",
            "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
          ],          
          "deployment": {
              "location": "westeurope",
              "properties": {
                  "mode": "incremental",
                  "template": {
                      "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
                      "contentVersion": "1.0.0.0",
                      "parameters": {
                        "exclusionTags": {
                          "type": "object"
                        },
                        "mdcObjectId": {
                          "type": "string"
                        }                        
                      },
                      "variables": {},
                      "resources": [
                          {
                            "type": "Microsoft.Authorization/roleAssignments",
                            "apiVersion": "2018-09-01-preview",
                            "name": "[variables('roleAssignmentName')]",
                            "properties": {
                              "roleDefinitionId": "[concat('/subscriptions/', subscription().subscriptionId, '/providers/Microsoft.Authorization/roleDefinitions/', 'd24ecba3-c1f4-40fa-a7bb-4588a071e8fd')]",
                              "principalId": "[parameters('mdcObjectId')]"
                            }
                          },                        
                          {
                            "type": "Microsoft.Security/vmScanners",
                            "name": "default",
                            "apiVersion": "2022-03-01-preview",
                            "properties": {
                              "scanningMode": "default",
                              "exclusionTags": "[parameters('exclusionTags')]"
                            },
                            "dependsOn": [
                              "[subscriptionResourceId('Microsoft.Authorization/roleAssignments', variables('roleAssignmentName'))]"
                            ]                            
                          }
                      ],
                      "outputs": {}
                    },
                    "parameters": {
                      "exclusionTags": {
                        "value": "[parameters('exclusionTags')]"
                      },
                      "mdcObjectId": {
                        "value": "[parameters('mdcObjectId')]"
                      }                      
                  }                    
                }
              }
            }
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
        "DeployIfNotExists",
        "Disabled"
      ],
      "defaultValue": "DeployIfNotExists"
    },
    "exclusionTags": {
      "type": "Object",
      "metadata": {
        "displayName": "Exclusion tags",
        "description": "Dictionary of string key-value pairs representing the tags used to exclude resources from being scanned. Resources tagged with one of these values will not be scanned. The values in the dictionary are case-sensitive"
      },
      "defaultValue": {}
    },
    "mdcObjectId": {
      "type": "String",
      "metadata": {
        "displayName": "Microsoft Defender for Cloud Servers Scanner Resource Provider Azure Active Directory Object ID",
        "description": "The object ID of 'Microsoft Defender for Cloud Servers Scanner Resource Provider' enterprise application. Unique per Azure AD tenant"
      }
    }            
  }
PARAMETERS
}

output "policydefinition_deploy-mde-agentless-scan" {
  value = azurerm_policy_definition.deploy-mde-agentless-scan
}