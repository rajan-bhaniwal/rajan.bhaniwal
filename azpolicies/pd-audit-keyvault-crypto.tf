resource "azurerm_policy_definition" "audit-keyvault-crypto" {
  name         = "audit-keyvault-crypto"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Keyvault must have crypto team groups assigned in access policy"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-KV-CTRL-20",
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
          "field": "type",
          "equals": "Microsoft.KeyVault/vaults"
    },
    "then": {
    "effect": "AuditIfNotExists",
    "details": {
      "type": "Microsoft.KeyVault/vaults",
      "existenceCondition": {
        "allOf": [
          {
            "count": {
              "field": "Microsoft.Keyvault/vaults/accessPolicies[*]",
              "where": {
                "field": "Microsoft.Keyvault/vaults/accessPolicies[*].objectId",
                "equals": "[parameters('ObjectId')]"
              }
            },
            "equals": 1
          }
        ]
      }
    }
  }
 }
POLICY_RULE
  parameters = <<PARAMETERS
  {
    "ObjectId": {
    "type": "String",
    "metadata": {
        "displayName": "Provide ObjectId for Crypto keyvault AD group",
        "decription": "Provide ObjectId for Crypto keyvault AD group."
      },
    "defaultValue": ""
    }
  }
PARAMETERS
}

output "policydefinition_audit-keyvault-crypto" {
  value = azurerm_policy_definition.audit-keyvault-crypto
}