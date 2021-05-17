resource "azurerm_policy_definition" "audit-keyvault-pub" {
  name         = "audit-keyvault-pub"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Azure Key Vault must disable public network access"
  description = "Disable public network access for your key vault so that it's not accessible over the public internet. This can reduce data leakage risks."
  
  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-KV-CTRL-11",
    "fim-12-ctrl": "NSEC.1",
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
            "equals": "Microsoft.KeyVault/vaults"
          },
          {
            "field": "Microsoft.KeyVault/vaults/networkAcls.defaultAction",
            "notEquals": "Deny"
          }
        ]
    },
    "then": {
    "effect": "Audit"
  }
 }
POLICY_RULE
}

output "policydefinition_audit-keyvault-pub" {
  value = azurerm_policy_definition.audit-keyvault-pub
}