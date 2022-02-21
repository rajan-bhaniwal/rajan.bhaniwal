resource "azurerm_policy_definition" "audit-agw-waf2-ver" {
  name         = "audit-agw-waf2-ver"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit - Web Application Firewall (WAF2) must be set to latest OWASP version for Application Gateways"
  description  = "Audit - Web Application Firewall (WAF2) must be set to latest OWASP version for Application Gateways"


  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ALL-CTRL-34",
    "fim-12-ctrl": "LOGM.1, LOGM.2, LOGM.3, DSEC.2",
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
          "equals": "Microsoft.Network/applicationGateways"
        },
        {
          "field": "Microsoft.Network/applicationGateways/firewallPolicy.id",
          "exists": "True"
        }
      ]
    },
    "then": {
      "effect": "[parameters('effect')]",
      "details": {
        "type": "Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies",
        "existenceCondition": {

              "count": {
              "field": "Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/managedRules.managedRuleSets[*]",
              "where": {
                "allOf": [
                  {
                  "field": "Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/managedRules.managedRuleSets[*].ruleSetType",
                  "equals": "OWASP"
                  },
                  {
                  "field": "Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/managedRules.managedRuleSets[*].ruleSetVersion",
                  "in": "[parameters('allowedOWASPversion')]"
                  }
                ]
              }
            },
            "greater": 1
        }
      }
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
        "AuditIfNotExists",
        "Deny",
        "Disabled"
      ],
      "defaultValue": "AuditIfNotExists"
    },
    "allowedOWASPversion": {
      "type": "Array",
      "metadata": {
        "displayName": "Allowed OWASP Version",
        "description": "Allowed OWASP Version"
      },
      "defaultValue": ["3.1", "3.2"]
    }
  }
PARAMETERS

}

output "policydefinition_audit-agw-waf2-ver" {
  value = azurerm_policy_definition.audit-agw-waf2-ver
}