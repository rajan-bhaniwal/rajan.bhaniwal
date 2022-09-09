resource "azurerm_policy_definition" "audit-ipgroup-any" {
  name         = "audit-ipgroup-any"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Azure IP Group must not contain *"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-AFW-CTRL-19",
    "fim-l2-ctrl": "",
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
          "equals": "Microsoft.Network/ipGroups"
        },
        {
          "count": {
            "field": "Microsoft.Network/ipGroups/ipAddresses[*]",
            "where": {
              "allOf": [
                {
                  "field": "Microsoft.Network/ipGroups/ipAddresses[*]",
                  "equals": "*"
                }
              ]
            }
          },
          "greater": 0
        }         
    ]
},
  "then": {
    "effect": "audit"
  }
}
POLICY_RULE
}

output "policydefinition_audit-ipgroup-any" {
  value = azurerm_policy_definition.audit-ipgroup-any
}