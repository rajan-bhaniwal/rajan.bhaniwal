resource "azurerm_policy_definition" "audit-adls-https" {
  name         = "audit-adls-https"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Data Lake Storage must be configured to use https only"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ADL-CTRL-15_21",
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
            "value": "[field('Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly')]",
            "equals": true
          }
        }
      }
  }
POLICY_RULE
}

output "policydefinition_audit-adls-https" {
  value = azurerm_policy_definition.audit-adls-https
}