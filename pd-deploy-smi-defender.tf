resource "azurerm_policy_definition" "deploy-smi-defender" {
  name         = "deploy-smi-defender"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy and Configure Azure Defender on SQL managed instances."
  description  = "This policy Enables Azure Defender on Azure SQL Managed Instances to detect anomalous activities indicating unusual and potentially harmful attempts to access or exploit databases."
  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-SMI-CTRL-15",
    "fim-l2-ctrl": "LOGM.1, LOGM.2, LOGM.3",
    "priority": "P2",
    "source" : "SCD",
    "exclude-reporting": "true",
    "exclude-from-alerts": "true"
    }

METADATA


  policy_rule = <<POLICY_RULE
{
"if": {
        "field": "type",
        "equals": "Microsoft.Sql/managedInstances"
    },
    "then": {
      "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.Sql/managedInstances/securityAlertPolicies",
          "name": "Default",
          "evaluationDelay": "AfterProvisioning",
          "existenceCondition": {
            "field": "Microsoft.Sql/managedInstances/securityAlertPolicies/state",
            "equals": "Enabled"
          },
          "roleDefinitionIds": [
            "/providers/microsoft.authorization/roleDefinitions/056cd41c-7e88-42e1-933e-88ba6a50c9c3"
          ],
          "deployment": {
            "properties": {
              "mode": "incremental",
              "template": {
                "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": {
                  "instanceName": {
                    "type": "string"
                  }
                },
                "variables": {},
                "resources": [
                  {
                    "name": "[concat(parameters('instanceName'), '/Default')]",
                    "type": "Microsoft.Sql/managedInstances/securityAlertPolicies",
                    "apiVersion": "2020-11-01-preview",
                    "properties": {
                      "state": "Enabled"
                    }
                  }
                ]
              },
              "parameters": {
                "instanceName": {
                  "value": "[field('name')]"
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

output "policydefinition_deploy-smi-defender" {
  value = azurerm_policy_definition.deploy-smi-defender
}