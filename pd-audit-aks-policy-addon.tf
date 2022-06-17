resource "azurerm_policy_definition" "audit-aks-policy-addon" {
  name         = "audit-aks-policy-addon"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Policy Add-on for Kubernetes service (AKS) should be installed and enabled on your clusters"
  description  = "Use Azure Policy Add-on to manage and report on the compliance state of your Azure Kubernetes Service (AKS) clusters. For more information, see https://aka.ms/akspolicydoc."
  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-AKS-CTRL-52",
    "fim-12-ctrl": "SECA.1",
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
            "equals": "Microsoft.ContainerService/managedClusters"
          },
          {
            "anyOf": [
              {
                "field": "Microsoft.ContainerService/managedClusters/addonProfiles.azurePolicy.enabled",
                "exists": "false"
              },
              {
                "field": "Microsoft.ContainerService/managedClusters/addonProfiles.azurePolicy.enabled",
                "equals": "false"
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
  parameters  = <<PARAMETERS
  {
      "effect": {
        "type": "String",
        "metadata": {
          "displayName": "Effect",
          "description": "Enable or disable the execution of the policy"
        },
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "defaultValue": "Audit"
      }   
  }
PARAMETERS
}

output "policydefinition_audit-aks-policy-addon" {
  value = azurerm_policy_definition.audit-aks-policy-addon
}