resource "azurerm_policy_definition" "audit-cdn-waf" {
  name         = "audit-cdn-waf"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit - Web Application Firewall (WAF) must be enabled for CDN Profile Endpoints"
  description  = "Audit - Web Application Firewall (WAF) must be enabled for CDN Profile Endpoints"


  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ALL-CTRL-13, AZR-ALL-CTRL-33",
    "fim-12-ctrl": "NSEC.1, DSEC.6",
    "priority": "P2",
    "source" : "SCD",
    "exclude-reporting": "true",
    "exclude-from-alerts": "true"
    }

METADATA


  policy_rule = <<POLICY_RULE
    {
    "if": {
      "anyOf": [
        {
              "allOf": [
            {
              "field": "type",
              "equals": "Microsoft.Cdn/profiles/endpoints"
            },
            {
              "field": "Microsoft.Cdn/profiles/endpoints/webApplicationFirewallPolicyLink.id",
              "exists": "false"
            }
          ]
        },
        {
          "allOf": [
            {
              "equals": "Microsoft.Cdn/profiles",
              "field": "type"
            },
            {
              "field": "Microsoft.Cdn/profiles/endpoints/webApplicationFirewallPolicyLink.id",
              "exists": "false"
            }
          ]
        }
      ]

    },
    "then": {
      "effect": "[parameters('effect')]"
      }
  }
POLICY_RULE

  parameters  = <<PARAMETERS
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

output "policydefinition_audit-cdn-waf" {
  value = azurerm_policy_definition.audit-cdn-waf
}