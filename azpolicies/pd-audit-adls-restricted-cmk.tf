resource "azurerm_policy_definition" "audit-adls-restricted-cmk" {
  name         = "audit-adls-restricted-cmk"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Data Lake Storage must be configured with CMK if Data Classification is Highly Restricted"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ADL-CTRL-14",
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
              "allOf": [
                {
                "field":"[concat('tags[', 'Data Classification', ']')]",
                "exists": "true"
                },
                {
                "field":"[concat('tags[', 'Data Classification', ']')]",
                "like": "Highly Restricted"
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
            "field": "Microsoft.Storage/storageAccounts/encryption.keySource",
            "contains": "Microsoft.Keyvault"
          }
        }
      }
  }
POLICY_RULE
}

output "policydefinition_audit-adls-restricted-cmk" {
  value = azurerm_policy_definition.audit-adls-restricted-cmk
}