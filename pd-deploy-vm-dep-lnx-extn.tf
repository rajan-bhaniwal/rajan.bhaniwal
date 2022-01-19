resource "azurerm_policy_definition" "deploy-vm-dep-lnx-extn" {
  name         = "deploy-vm-dep-lnx-extn"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy - Configure Dependency agent to be enabled on Linux virtual machines"
  description  = "Deploy Dependency agent for Linux virtual machines if the virtual machine image is in the list defined and the agent is not installed."

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
              "equals": "Microsoft.Compute/virtualMachines"
            },
            {
              "anyOf": [
                  {
                    "field": "Microsoft.Compute/virtualMachines/osProfile.linuxConfiguration",
                    "exists": "true"
                  },
                  {
                    "field": "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType",
                    "like": "Linux*"
                  }
              ]
            }
        ]
    },
      "then": {
        "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.Compute/virtualMachines",
          "roleDefinitionIds": [
            "/providers/microsoft.authorization/roleDefinitions/9980e02c-c2be-4d73-94e8-173b1dc7cf3c"
          ],
          "existenceCondition": {
            "allOf": [
              {
                "field": "Microsoft.Compute/virtualMachines/extensions/type",
                "equals": "DependencyAgentLinux"
              },
              {
                "field": "Microsoft.Compute/virtualMachines/extensions/publisher",
                "equals": "Microsoft.Azure.Monitoring.DependencyAgent"
              },
              {
                "field": "Microsoft.Compute/virtualMachines/extensions/provisioningState",
                "equals": "Succeeded"
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
                  "vmName": {
                    "type": "string"
                  },
                  "location": {
                    "type": "string"
                  }
                },
                "variables": {
                  "vmExtensionName": "DependencyAgentLinux",
                  "vmExtensionPublisher": "Microsoft.Azure.Monitoring.DependencyAgent",
                  "vmExtensionType": "DependencyAgentLinux",
                  "vmExtensionTypeHandlerVersion": "9.6"
                },
                "resources": [
                  {
                    "type": "Microsoft.Compute/virtualMachines/extensions",
                    "name": "[concat(parameters('vmName'), '/', variables('vmExtensionName'))]",
                    "apiVersion": "2019-12-01",
                    "location": "[parameters('location')]",
                    "properties": {
                      "publisher": "[variables('vmExtensionPublisher')]",
                      "type": "[variables('vmExtensionType')]",
                      "typeHandlerVersion": "[variables('vmExtensionTypeHandlerVersion')]",
                      "autoUpgradeMinorVersion": true,
                      "enableAutomaticUpgrade": true
                    }
                  }
                ],
                "outputs": {
                  "policy": {
                    "type": "string",
                    "value": "[concat('Enabled extension for VM', ': ', parameters('vmName'))]"
                  }
                }
              },
              "parameters": {
                "vmName": {
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

output "policydefinition_deploy-vm-dep-lnx-extn" {
  value = azurerm_policy_definition.deploy-vm-dep-lnx-extn
}