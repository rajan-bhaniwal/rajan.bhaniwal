resource "azurerm_policy_definition" "audit-adls-defender" {
  name         = "audit-adls-defender"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Data Lake Storage must be configured to use Azure Defender for BIA rating Major and above"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ADL-CTRL-37-38",
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
              "field":"Microsoft.Storage/storageAccounts/isHnsEnabled",
              "Equals": true
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

output "policydefinition_audit-adls-defender" {
  value = azurerm_policy_definition.audit-adls-defender
}