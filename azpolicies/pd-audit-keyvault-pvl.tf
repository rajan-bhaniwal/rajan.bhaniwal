resource "azurerm_policy_definition" "audit-keyvault-pvl" {
  name         = "audit-keyvault-pvl"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Keyvault should use a private link connection"
  description = "Azure Private Link lets you connect your virtual networks to Azure services without a public IP address at the source or destination. The Private Link platform handles the connectivity between the consumer and services over the Azure backbone network. By mapping private endpoints to key vault, you can reduce data leakage risks."
  
  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-PVL-CTRL-11",
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
            "count": {
              "field": "Microsoft.KeyVault/vaults/privateEndpointConnections[*]",
              "where": {
                "field": "Microsoft.KeyVault/vaults/privateEndpointConnections[*].privateLinkServiceConnectionState.status",
                "equals": "Approved"
              }
            },
            "less": 1
          }
        ]
    },
    "then": {
    "effect": "Audit"
  }
 }
POLICY_RULE
}

output "policydefinition_audit-keyvault-pvl" {
  value = azurerm_policy_definition.audit-keyvault-pvl
}