resource "azurerm_policy_definition" "audit-adls-pvl" {
  name         = "audit-adls-pvl"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Azure Data Lake Storage must be configured use a private link connection"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ADL-CTRL-17",
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
        "equals": "Microsoft.Storage/storageAccounts"
        },
        {
          "field":"Microsoft.Storage/storageAccounts/isHnsEnabled",
          "Equals": true
        }
      ]
  },
  "then": {
    "effect": "AuditIfNotExists",
    "details": {
      "type": "Microsoft.Storage/storageAccounts/privateEndpointConnections",
      "existenceCondition": {
        "allOf": [
          {
            "field": "Microsoft.Storage/storageAccounts/privateEndpointConnections/privateEndpoint",
            "exists": "true"
          },
          {
            "field": "Microsoft.Storage/storageAccounts/privateEndpointConnections/provisioningState",
            "equals": "Succeeded"
          },
          {
            "field": "Microsoft.Storage/storageAccounts/privateEndpointConnections/privateLinkServiceConnectionState",
            "exists": "true"
          },
          {
            "field": "Microsoft.Storage/storageAccounts/privateEndpointConnections/privateLinkServiceConnectionState.status",
            "equals": "Approved"
          }
        ]
      }
    }
  }                
}
POLICY_RULE
}

output "policydefinition_audit-adls-pvl" {
  value = azurerm_policy_definition.audit-adls-pvl
}