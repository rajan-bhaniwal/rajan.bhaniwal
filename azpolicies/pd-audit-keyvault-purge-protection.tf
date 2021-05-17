resource "azurerm_policy_definition" "audit-keyvault-purge-protection" {
  name         = "audit-keyvault-purge-protection"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Key Vault should have Pruge protection enabled"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "13",
    "fim-12-ctrl": "",
    "priority": "P2",
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
            "equals": "Microsoft.KeyVault/vaults"
          },
          {
            "anyOf": [
              {
                "field": "Microsoft.KeyVault/vaults/enablePurgeProtection",
                "exists": "false"
              },
              {
                "field": "Microsoft.KeyVault/vaults/enablePurgeProtection",
                "equals": "false"
              }
            ]
          }
        ]
    },
    "then": {
      "effect": "audit"
    }
  }
POLICY_RULE
}

output "policydefinition_audit-keyvault-purge-protection" {
  value = azurerm_policy_definition.audit-keyvault-purge-protection
}