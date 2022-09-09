resource "azurerm_policy_definition" "audit-azurefw-any-any-natrules" {
  name         = "audit-azurefw-any-any-natrules"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Azure Firewall NAT rule collection must not use '*' as source IP"

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
          "equals": "Microsoft.Network/azureFirewalls"
        },
        {
          "count": {
          "field": "Microsoft.Network/azureFirewalls/natRuleCollections[*]",
          "where": {
            "allOf": [
              {
                "count": {
                  "field": "Microsoft.Network/azureFirewalls/natRuleCollections[*].rules[*]",
                  "where": {
                    "anyOf": [
                          { 
                          "allOf": [                                                
                                {
                                  "field": "Microsoft.Network/azureFirewalls/natRuleCollections[*].rules[*].sourceAddresses[*]",
                                  "exists": true
                                },
                                {
                                  "count": {
                                    "field": "Microsoft.Network/azureFirewalls/natRuleCollections[*].rules[*].sourceAddresses[*]",
                                    "where": {                                                          
                                                "field": "Microsoft.Network/azureFirewalls/natRuleCollections[*].rules[*].sourceAddresses[*]",
                                                "equals": "*"
                                              }
                                            },
                                            "greater": 0
                                }
                            ] 
                          }                      
                        ]
                      }
                    },
                    "greater": 0
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

output "policydefinition_audit-azurefw-any-any-natrules" {
  value = azurerm_policy_definition.audit-azurefw-any-any-natrules
}