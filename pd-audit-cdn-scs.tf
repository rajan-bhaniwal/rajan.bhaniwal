resource "azurerm_policy_definition" "audit-cdn-scs" {
  name         = "audit-cdn-scs"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure CDN endpoint must enable Geo-Filtering to block HSBC Global Sanctioned Countries."
  description  = "Azure CDN endpoint must enable Geo-Filtering to block HSBC Global Sanctioned Countries."


  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-CDN-CTRL-24",
    "fim-l2-ctrl": "NRES.1, DEPL.4",
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
            "field": "type",
            "equals": "Microsoft.Cdn/profiles/endpoints"
          },
          {
              "count": {
                  "field": "Microsoft.Cdn/profiles/endpoints/geoFilters[*]",
                  "where": {
                      "allOf": [
                          {
                            "field": "Microsoft.Cdn/profiles/endpoints/geoFilters[*].action",
                            "equals": "Block"
                          },
                          {
                             "count": {
                                "field": "Microsoft.Cdn/profiles/endpoints/geoFilters[*].countryCodes[*]",
                                "where": {
                                  "field": "Microsoft.Cdn/profiles/endpoints/geoFilters[*].countryCodes[*]",
                                  "in": "[parameters('sanctionedCountryCodes')]"
                                }
                              },
                              "greater": 0
                          }
                      ]
                  }
              },
              "less": 1
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
    },
    "sanctionedCountryCodes": {
      "type": "Array",
      "metadata": {
        "displayName": "List of HSBC Global Sanctioned Country Code",
        "description": "List of HSBC Global Sanctioned Country Code. https://github.com/rgl/azure-content/blob/master/articles/cdn/cdn-country-codes.md"
      },
      "defaultValue": [
      "AL"
      ]
    }
  }
PARAMETERS

}

output "policydefinition_audit-cdn-scs" {
  value = azurerm_policy_definition.audit-cdn-scs
}