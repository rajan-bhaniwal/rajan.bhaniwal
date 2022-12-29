resource "azurerm_policy_definition" "audit-ml-pub" {
  name         = "audit-ml-pub"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Machine Learning workspaces must not enable public network access"
  description  = "Azure Machine Learning workspaces must not enable public network access. Use private link to access data and control plane."


  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ML-CTRL-11, AZR-ML-CTRL-13",
    "fim-l2-ctrl": "NSEC.1, DSEC.4",
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
            "equals": "Microsoft.MachineLearningServices/workspaces"
          },
          {
            "anyOf": [
              {
                "field": "Microsoft.MachineLearningServices/workspaces/publicNetworkAccess",
                "exists": "false"
              },
              {
                "field": "Microsoft.MachineLearningServices/workspaces/publicNetworkAccess",
                "notEquals": "Disabled"
              }
            ]
          }
        ]
    },
    "then": {
      "effect": "[parameters('effect')]"
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
        "Audit",
        "Deny",
        "Disabled"
      ],
      "defaultValue": "Audit"
    }
  }
PARAMETERS

}

output "policydefinition_audit-ml-pub" {
  value = azurerm_policy_definition.audit-ml-pub
}