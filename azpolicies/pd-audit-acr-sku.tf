resource "azurerm_policy_definition" "audit-acr-sku" {
  name         = "audit-acr-sku"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Container registries must use Premium SKU that support Private Links and Retention features"
  description  = "Azure Container registries must use Premium SKU that support Private Links and Retention features"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ACR-CTRL-12,AZR-ACR-CTRL-19",
    "fim-12-ctrl": "NSEC.1, ITOP.4",
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
            "field": "Microsoft.ContainerRegistry/registries/sku.name",
            "notEquals": "Premium"
          }
        ]
    },
    "then": {
    "effect": "Audit"
  }
 }
POLICY_RULE
}

output "policydefinition_audit-acr-sku" {
  value = azurerm_policy_definition.audit-acr-sku
}