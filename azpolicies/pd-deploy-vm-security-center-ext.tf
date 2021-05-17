resource "azurerm_policy_definition" "deploy-vm-security-center-ext" {
  name         = "deploy-vm-security-center-ext"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy AzureSecurityCenter vulnerability assessment extension on virtual machines"
  description  = "This policy deploys AzureSecurityCenter vulnerability assessment extension to Windows and Linux virtual machines." 

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "",
    "fim-12-ctrl": "",
    "priority": "P2",
    "source" : "azsk",
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
          }
        ]
      },
      "then": {
        "effect": "deployIfNotExists",
        "details": {
          "roleDefinitionIds": [
            "/providers/microsoft.authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
          ],
          "type": "Microsoft.Compute/virtualMachines/extensions",
          "existenceCondition": {
            "allOf": [
              {
                "field": "Microsoft.Compute/virtualMachines/extensions/type",
                "like": "*AzureSecurityCenter"
              },
              {
                "field": "Microsoft.Compute/virtualMachines/extensions/publisher",
                "equals": "Qualys"
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
              "parameters": {
                "vmName": {
                  "value": "[field('name')]"
                },
                "location": {
                  "value": "[field('location')]"
                }
              },
              "template": {
                "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": {
                  "vmName": {
                    "type": "string"
                  },
                  "location": {
                    "type": "string"
                  }
                },
                "resources": [
                  {
                    "apiVersion": "2020-01-01",
                    "type": "Microsoft.Compute/virtualMachines/providers/serverVulnerabilityAssessments",
                    "name": "[concat(parameters('vmName'), '/Microsoft.Security/default')]",
                    "location": "[parameters('location')]"
                  }
                ]
              }
            }
          }
        }
      }
    }
POLICY_RULE
}

output "policydefinition_deploy-vm-security-center-ext" {
  value = azurerm_policy_definition.deploy-vm-security-center-ext
}