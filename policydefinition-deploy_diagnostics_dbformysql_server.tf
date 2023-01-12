resource "azurerm_policy_definition" "deploy_diagnostics_DBforMySQL_servers" {
  name         = "deploy-diagnostics-DBforMySQL_servers"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy-Diagnostics-DBforMySQL-Servers"
  description  = "Deploy diagnostics settings for Azure DBforMySQL Servers - Log Analytics"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "",
    "fim-l2-ctrl": "",
    "priority": "P2",
    "source" : "",
    "exclude-reporting": "true",
    "exclude-from-alerts": "true"
    }

METADATA


  policy_rule = <<POLICY_RULE
    {
    "if": {
      "field": "type",
      "equals": "Microsoft.DBforMySQL/servers"
    },
    "then": {
      "effect": "DeployIfNotExists",
      "details": {
              "type": "Microsoft.Insights/diagnosticSettings",
              "existenceCondition": {
                "allOf": [
                  {
                  "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
                  "equals": "[parameters('logAnalytics')]"
                  },
                  {
                    "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
                    "equals": "true"
                  },
                  {
                    "field": "Microsoft.Insights/diagnosticSettings/metrics.enabled",
                    "equals": "true"
                  }
                ]
              },
              "roleDefinitionIds": [
                "/providers/microsoft.authorization/roleDefinitions/6d8ee4ec-f05a-4a1d-8b00-a9b17e38b437"
              ],
              "deployment": {
                "properties": {
                  "mode": "incremental",
                  "template": {
                    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                      "fullName": {
                        "type": "string"
                      },
                      "location": {
                        "type": "string"
                      },
                      "logAnalytics": {
                        "type": "string"
                      },
                      "metricsEnabled": {
                        "type": "string"
                      },
                      "logsEnabled": {
                        "type": "string"
                      },
                      "profileName": {
                        "type": "string"
                      }
                    },
                    "resources": [
                      {
                        "type": "Microsoft.DBforMySQL/servers/providers/diagnosticSettings",
                        "apiVersion": "2021-05-01-preview",
                        "name": "[concat(parameters('fullName'), '/', 'Microsoft.Insights/', parameters('profileName'))]",
                        "location": "[parameters('location')]",
                        "dependsOn": [],
                        "properties": {
                          "workspaceId": "[parameters('logAnalytics')]",
                          "metrics": [
                            {
                              "category": "AllMetrics",
                              "enabled": "[parameters('metricsEnabled')]",
                              "retentionPolicy": {
                                "enabled": false,
                                "days": 0
                              }
                            }
                          ],
                          "logs": [
                            {
                              "category":  "MySqlSlowLogs",
                              "enabled":  "[parameters('logsEnabled')]"
                            },
                            {
                              "category":  "MySqlAuditLogs",
                              "enabled":  "[parameters('logsEnabled')]"
                            }
                          ]
                        }
                      }
                    ],
                    "outputs": {
                      "policy": {
                        "type": "string",
                        "value": "[concat('Enabled diagnostic settings for ', parameters('fullName'))]"
                      }
                    }
                  },
                  "parameters": {
                    "location": {
                      "value": "[field('location')]"
                    },
                    "fullName": {
                      "value": "[field('fullName')]"
                    },
                    "logAnalytics": {
                      "value": "[parameters('logAnalytics')]"
                    },
                    "metricsEnabled": {
                      "value": "true"
                    },
                    "logsEnabled": {
                      "value": "true"
                    },
                    "profileName": {
                      "value": "setByPolicy"
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
    "logAnalytics": {
    "type": "String",
    "metadata": {
        "displayName": "Log Analtics workspace",
        "decription": "Select Log Anlaytics workspace from from dropdown list.",
        "strongType": "omsWorkspace",
        "assignPermissions": true
      }
    }
  }
PARAMETERS

}

output "policydefinition_deploy_diagnostics_DBforMySQL_servers" {
  value = azurerm_policy_definition.deploy_diagnostics_DBforMySQL_servers
}