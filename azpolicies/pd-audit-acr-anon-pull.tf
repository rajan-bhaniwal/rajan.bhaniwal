resource "azurerm_policy_definition" "audit-acr-anon-pull" {
  name         = "audit-acr-anon-pull"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Container registries anonymous pull access must be disabled."
  description  = "Secure your Container registries by disabling anonymous pull access."

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ACR-CTRL-01",
    "fim-12-ctrl": "IDAM.4",
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
            "field": "Microsoft.ContainerRegistry/registries/anonymousPullEnabled",
            "notEquals": false
          }
        ]
    },
    "then": {
    "effect": "Audit"
  }
 }
POLICY_RULE
}

output "policydefinition_audit-acr-anon-pull" {
  value = azurerm_policy_definition.audit-acr-anon-pull
}