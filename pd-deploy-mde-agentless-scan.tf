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
                        }
                      },
                      "variables": {},
                      "resources": [
                          {
                            "type": "Microsoft.Security/vmScanners",
                            "name": "default",
                            "apiVersion": "2022-03-01-preview",
                            "properties": {
                              "scanningMode": "default",
                              "exclusionTags": "[parameters('exclusionTags')]"
                            }
                          }
                      ],
                      "outputs": {}
                    },
                    "parameters": {
                      "exclusionTags": {
                        "value": "[parameters('exclusionTags')]"
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
    }        
  }
PARAMETERS
}

output "policydefinition_deploy-mde-agentless-scan" {
  value = azurerm_policy_definition.deploy-mde-agentless-scan
}