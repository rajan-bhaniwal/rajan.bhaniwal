resource "azurerm_policy_definition" "audit-adls-blob-puba" {
  name         = "audit-adls-blob-puba"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Data Lake Storage must not allow blob public access"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ADL-CTRL-36",
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
            }
          ]
      },
      "then": {
        "effect": "auditIfNotExists",
        "details": {
          "type": "Microsoft.Storage/storageAccounts",
          "existenceCondition": {
            "value": "[field('Microsoft.Storage/storageAccounts/allowBlobPublicAccess')]",
            "equals": false
          }
        }
      }
  }
POLICY_RULE
}

output "policydefinition_audit-adls-blob-puba" {
  value = azurerm_policy_definition.audit-adls-blob-puba
}