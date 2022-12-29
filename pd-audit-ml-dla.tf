resource "azurerm_policy_definition" "audit-ml-dla" {
  name         = "audit-ml-dla"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Machine Learning computes should have local authentication methods disabled"
  description  = "Azure Machine Learning computes should have local authentication methods disabled. Disabling local authentication methods improves security by ensuring that Machine Learning computes require Azure Active Directory identities exclusively for authentication."


  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "Governance",
    "fim-l2-ctrl": "Governance",
    "priority": "P2",
    "source" : "Governance",
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
            "equals": "Microsoft.MachineLearningServices/workspaces/computes"
          },
          {
            "field": "Microsoft.MachineLearningServices/workspaces/computes/disableLocalAuth",
            "notEquals": true
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

output "policydefinition_audit-ml-dla" {
  value = azurerm_policy_definition.audit-ml-pub
}