resource "azurerm_policy_definition" "audit-container-pvl" {
  name         = "audit-container-pvl"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Container registries should use a private link connection"
  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-PVL-CTRL-11",
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
        "equals": "Microsoft.ContainerRegistry/registries"
      },
      {
        "count": {
          "field": "Microsoft.ContainerRegistry/registries/privateEndpointConnections[*]",
          "where": {
            "field": "Microsoft.ContainerRegistry/registries/privateEndpointConnections[*].privateLinkServiceConnectionState.status",
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

output "policydefinition_audit-container-pvl" {
  value = azurerm_policy_definition.audit-container-pvl
}