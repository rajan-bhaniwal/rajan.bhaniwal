resource "azurerm_policy_definition" "audit-adls-fw" {
  name         = "audit-adls-fw"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Data Lake Storage must be configured to use firewall"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ADL-CTRL-18-20",
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
              "not": {
                "field":"Microsoft.Storage/storageAccounts/isHnsEnabled",
                "exists": "false"
                }
            },
            {
              "field": "Microsoft.Storage/storageAccounts/networkAcls.defaultAction",
              "notEquals": "Deny"
            }
          ]
      },
      "then": {
        "effect": "audit"
      }
  }
POLICY_RULE
}

output "policydefinition_audit-adls-fw" {
  value = azurerm_policy_definition.audit-adls-fw
}