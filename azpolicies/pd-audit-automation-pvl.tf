resource "azurerm_policy_definition" "audit-automation-pvl" {
  name         = "audit-automation-pvl"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Azure Automation Account should use a private link connection"

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
          "field": "type",
          "equals": "Microsoft.Automation/automationAccounts"
    },
    "then": {
    "effect": "AuditIfNotExists",
    "details": {
      "type": "Microsoft.Automation/automationAccounts/privateEndpointConnections",
      "existenceCondition": {
        "allOf": [
          {
            "field": "Microsoft.Automation/automationAccounts/privateEndpointConnections/privateEndpoint",
            "exists": "true"
          },
          {
            "field": "Microsoft.Automation/automationAccounts/privateEndpointConnections/privateLinkServiceConnectionState",
            "exists": "true"
          },
          {
            "field": "Microsoft.Automation/automationAccounts/privateEndpointConnections/privateLinkServiceConnectionState.status",
            "equals": "Approved"
          }
        ]
      }
    }
  }
 }
POLICY_RULE
}

output "policydefinition_audit-automation-pvl" {
  value = azurerm_policy_definition.audit-automation-pvl
}