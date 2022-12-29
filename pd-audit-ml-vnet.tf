resource "azurerm_policy_definition" "audit-ml-vnet" {
  name         = "audit-ml-vnet"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Machine Learning Compute Cluster and Instance is behind virtual network"
  description  = "Azure Machine Learning Compute Cluster and Instance is behind virtual network. Azure Virtual Network deployment provides enhanced security and isolation for your Azure Machine Learning Compute Clusters and Instances, as well as subnets, access control policies, and other features to further restrict access.When am Azure Machine Learning Compute instance is configured with a virtual network, it is not publicly addressable and can only be accessed from virtual machines and applications within the virtual network."


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
            "equals": "Microsoft.MachineLearningServices/workspaces/computes"
          },
          {
            "field": "Microsoft.MachineLearningServices/workspaces/computes/computeType",
            "in": [
              "AmlCompute",
              "ComputeInstance"
            ]
          },
          {
            "anyOf": [
              {
                "field": "Microsoft.MachineLearningServices/workspaces/computes/subnet.id",
                "exists": false
              },
              {
                "value": "[empty(field('Microsoft.MachineLearningServices/workspaces/computes/subnet.id'))]",
                "equals": true
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

output "policydefinition_audit-ml-vnet" {
  value = azurerm_policy_definition.audit-ml-pub
}