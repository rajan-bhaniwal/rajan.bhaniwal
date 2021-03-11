resource "azurerm_policy_definition" "audit-adls-sku" {
  name         = "audit-adls-sku"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Data Lake Storage must not use LRS sku for BIA rating Moderate and above"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ADL-CTRL-25",
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
                  "like": "Moderate"
                },
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
          "type": "Microsoft.Storage/storageAccounts",
          "existenceCondition": {
            "value": "[field('Microsoft.Storage/storageAccounts/sku.name')]",
            "notequals": "Standard_LRS"
          }
        }
      }
  }
POLICY_RULE
}

output "policydefinition_audit-adls-sku" {
  value = azurerm_policy_definition.audit-adls-sku
}