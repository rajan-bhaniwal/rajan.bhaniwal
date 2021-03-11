resource "azurerm_policy_definition" "audit-storage-defender" {
  name         = "audit-storage-defender"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Storage Accounts must be configured to use Azure Defender for BIA rating Major and above"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ABS-CTRL-46-47",
    "fim-12-ctrl": "",
    "priority": "P1",
    "source" : "",
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
            "equals": "Microsoft.Storage/storageAccounts"
            },
            {
                "field":"[concat('tags[', 'BIA', ']')]",
                "exists": "true"
            },
            {
            "anyOf": [
                {
                  "field":"[concat('tags[', 'BIA', ']')]",
                  "like": "Major"
                },
                {
                  "field":"[concat('tags[', 'BIA', ']')]",
                  "Like": "Extreme"
                }
            ]
          }
      
          ]
      },
      "then": {
        "effect": "auditIfNotExists",
        "details": {
          "type": "Microsoft.Security/pricings",
          "name": "StorageAccounts",
          "existenceScope": "subscription",
          "existenceCondition": {
            "field": "Microsoft.Security/pricings/pricingTier",
            "equals": "Standard"
          }
        }
      }
  }
POLICY_RULE
}

output "policydefinition_audit-storage-defender" {
  value = azurerm_policy_definition.audit-storage-defender
}