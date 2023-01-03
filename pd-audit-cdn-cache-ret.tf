resource "azurerm_policy_definition" "audit-cdn-cache-ret" {
  name         = "audit-cdn-cache-ret"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure CDN endpoint must not set Cache Expiration duration over 90 Days."
  description  = "Azure CDN endpoint must not set Cache Expiration duration over 90 Days."


  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-CDN-CTRL-25",
    "fim-l2-ctrl": "DEPL.4",
    "priority": "P2",
    "source" : "SCD",
    "exclude-reporting": "true",
    "exclude-from-alerts": "true"
    }

METADATA


  policy_rule = <<POLICY_RULE
    {
    "if": {
        "allOf": [
          {
            "equals": "Microsoft.Cdn/profiles/endpoints",
            "field": "type"
          },
          {
            "count": {
              "field": "Microsoft.Cdn/profiles/endpoints/deliveryPolicy.rules[*]",
              "where": {
                  "count": {
                    "field": "Microsoft.Cdn/profiles/endpoints/deliveryPolicy.rules[*].actions[*]",
                    "where": {          
                          "allOf": [
                            {
                              "field": "Microsoft.Cdn/profiles/endpoints/deliveryPolicy.rules[*].actions[*].name",
                              "equals": "CacheExpiration"
                            },
                            {
                              "greater": "90.00:00:00",
                              "field": "Microsoft.Cdn/profiles/endpoints/deliveryPolicy.rules[*].actions[*].CacheExpiration.parameters.cacheDuration"
                            }
                          ]
                        }
                  },
                  "greater": 0
              }
            },
            "greater": 0
          }
        ]
    },
    "then": {
      "effect": "[parameters('effect')]"
      }
  }
POLICY_RULE

  parameters = <<PARAMETERS
  {
    "effect": {
      "type": "String",
      "metadata": {
        "displayName": "Effect",
        "description": "Enable or disable the execution of the policy"
      },
      "allowedValues": [
        "Audit",
        "Deny",
        "Disabled"
      ],
      "defaultValue": "Audit"
    }
  }
PARAMETERS

}

output "policydefinition_audit-cdn-cache-ret" {
  value = azurerm_policy_definition.audit-cdn-cache-ret
}