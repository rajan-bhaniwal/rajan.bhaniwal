resource "azurerm_policy_definition" "audit-azurefw-any-any-ntwrules" {
  name         = "audit-azurefw-any-any-ntwrules"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Azure Firewall Network rule collection must not use promiscuous Any Any"

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
          "field": "Microsoft.Network/azureFirewalls/networkRuleCollections[*]",
          "where": {
            "allOf": [
              {
              "field": "Microsoft.Network/azureFirewalls/networkRuleCollections[*].action.type",
              "equals": "Allow"
              },
              {
                "count": {
                  "field": "Microsoft.Network/azureFirewalls/networkRuleCollections[*].rules[*]",
                  "where": {
                    "anyOf": [
                          { 
                          "allOf": [                                                
                                {
                                  "field": "Microsoft.Network/azureFirewalls/networkRuleCollections[*].rules[*].sourceAddresses[*]",
                                  "exists": true
                                },
                                {
                                  "count": {
                                    "field": "Microsoft.Network/azureFirewalls/networkRuleCollections[*].rules[*].sourceAddresses[*]",
                                    "where": {                                                          
                                                "field": "Microsoft.Network/azureFirewalls/networkRuleCollections[*].rules[*].sourceAddresses[*]",
                                                "equals": "*"
                                              }
                                            },
                                            "greater": 0
                                }
                            ] 
                          },
                          { 
                          "allOf": [                                                                         
                                {
                                  "field": "Microsoft.Network/azureFirewalls/networkRuleCollections[*].rules[*].destinationAddresses[*]",
                                  "exists": true
                                },                          
                                {
                                  "count": {
                                    "field": "Microsoft.Network/azureFirewalls/networkRuleCollections[*].rules[*].destinationAddresses[*]",
                                    "where": {                                                          
                                                "field": "Microsoft.Network/azureFirewalls/networkRuleCollections[*].rules[*].destinationAddresses[*]",
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

output "policydefinition_audit-azurefw-any-any-ntwrules" {
  value = azurerm_policy_definition.audit-azurefw-any-any-ntwrules
}