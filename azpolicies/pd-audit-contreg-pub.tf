resource "azurerm_policy_definition" "audit-contreg-pub" {
  name         = "audit-contreg-pub"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Public network access should be disabled for Container registries"
  description  = "Disabling public network access improves security by ensuring that container registries are not exposed on the public internet. Creating private endpoints can limit exposure of container registry resources." 

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ACR-CTRL-11",
    "fim-12-ctrl": "NSEC,1",
    "priority": "P1",
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
        "field": "Microsoft.ContainerRegistry/registries/publicNetworkAccess",
        "notEquals": "Disabled"
      }
    ]
  },
  "then": {
    "effect": "Audit"
  }                
}
POLICY_RULE
}

output "policydefinition_audit-contreg-pub" {
  value = azurerm_policy_definition.audit-contreg-pub
}