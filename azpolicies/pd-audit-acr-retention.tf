resource "azurerm_policy_definition" "audit-acr-retention" {
  name         = "audit-acr-retention"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Container registries must be set for 30 days retention policy for untagged manifests."
  description  = "Azure Container registries must be set for 30 days retention policy for untagged manifests https://docs.microsoft.com/en-us/azure/container-registry/container-registry-retention-policy"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ACR-CTRL-19",
    "fim-12-ctrl": "ITOP.4",
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
            "equals": "Microsoft.ContainerRegistry/registries"
          }
        ]
    },
      "then": {
        "effect": "auditIfNotExists",
        "details": {
          "type": "Microsoft.ContainerRegistry/registries",
          "existenceCondition": {
            "allOf": [
              {
                "field": "Microsoft.ContainerRegistry/registries/policies.retentionPolicy.status",
                "equals": "enabled"
              },
              {
                "field": "Microsoft.ContainerRegistry/registries/policies.retentionPolicy.days",
                "greaterOrEquals": 30
              }
            ]
          }
        }
      }
  }
POLICY_RULE
}

output "policydefinition_audit-acr-retention" {
  value = azurerm_policy_definition.audit-acr-retention
}