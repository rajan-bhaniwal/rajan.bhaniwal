resource "azurerm_policy_definition" "audit-acr-cont-trust" {
  name         = "audit-acr-cont-trust"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Container registries content trust must be enabled"
  description  = "Container registries content trust must be enabled https://docs.microsoft.com/en-us/azure/container-registry/container-registry-content-trust"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ACR-CTRL-13",
    "fim-12-ctrl": "DSEC.5",
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
          },
          {
            "field": "Microsoft.ContainerRegistry/registries/policies.trustPolicy.status",
            "notEquals": "enabled"
          }
        ]
    },
    "then": {
    "effect": "Audit"
  }
 }
POLICY_RULE
}

output "policydefinition_audit-acr-cont-trust" {
  value = azurerm_policy_definition.audit-acr-cont-trust
}