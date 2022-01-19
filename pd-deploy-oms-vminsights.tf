resource "azurerm_policy_definition" "deploy-oms-vminsights" {
  name         = "deploy-oms-vminsights"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy - Log Analytics workspace with VM Insights solution"
  description  = "Deploy - Log Analytics workspace with VM Insights solution"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-VMLP-CTRL-14,16|AZR-VMLC-CTRL-11",
    "fim-12-ctrl": "SDLC1, SECA.1,PROT.2,ITAM.4,ITOP2,VULN.1",
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
              "equals": "Microsoft.OperationalInsights/workspaces"
            }
        ]
    },
      "then": {
        "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.OperationsManagement/solutions",
          "roleDefinitionIds": [
            "/providers/microsoft.authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293"
          ],
          "existenceCondition": {
            "allOf": [
              {
                "field": "Microsoft.OperationsManagement/solutions/provisioningState",
                "equals": "Succeeded"
              },
              {
                "field": "name",
                "like": "vmInsights*"
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

                  "location": {
                    "type": "string"
                  },
                  "logAnalyticsWorkspaceName": {
                    "type": "string"
                  }
                },
                "variables": {
                  "vmInsights": {
                    "name": "[format('VMInsights({0})', parameters('logAnalyticsWorkspaceName'))]",
                    "galleryName": "VMInsights"
                  }
                },
                "resources": [
                  {
                    "type": "Microsoft.OperationsManagement/solutions",
                    "apiVersion": "2015-11-01-preview",
                    "name": "[variables('vmInsights').name]",
                    "location": "[parameters('location')]",
                    "properties": {
                      "workspaceResourceId": "[resourceId('Microsoft.OperationalInsights/workspaces', parameters('logAnalyticsWorkspaceName'))]"
                    },
                    "plan": {
                      "name": "[variables('vmInsights').name]",
                      "publisher": "Microsoft",
                      "product": "[format('OMSGallery/{0}', variables('vmInsights').galleryName)]",
                      "promotionCode": ""
                    }
                  }
                ],
                "outputs": {
                }
              },
              "parameters": {
                "logAnalyticsWorkspaceName": {
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
    }    
  }
PARAMETERS
}

output "policydefinition_deploy-oms-vminsights" {
  value = azurerm_policy_definition.deploy-oms-vminsights
}