resource "azurerm_policy_definition" "audit-aks-defender-profile" {
  name         = "audit-aks-defender-profile"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Azure Kubernetes Service clusters to enable Defender profile"
  description  = "Microsoft Defender for Containers provides cloud-native Kubernetes security capabilities including environment hardening, workload protection, and run-time protection. When you enable the SecurityProfile.AzureDefender on your Azure Kubernetes Service cluster, an agent is deployed to your cluster to collect security event data. Learn more about Microsoft Defender for Containers: https://docs.microsoft.com/azure/defender-for-cloud/defender-for-containers-introduction?tabs=defender-for-container-arch-aks."
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
            "field": "Microsoft.ContainerService/managedClusters/securityProfile.azureDefender.enabled",
            "notEquals": true
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

output "policydefinition_audit-aks-defender-profile" {
  value = azurerm_policy_definition.audit-aks-defender-profile
}