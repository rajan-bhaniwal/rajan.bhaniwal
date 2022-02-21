resource "azurerm_policy_definition" "audit-agw-waf-ver" {
  name         = "audit-agw-waf-ver"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit - Web Application Firewall (WAF) must be set to latest OWASP version for Application Gateways"
  description  = "Audit - Web Application Firewall (WAF) must be set to latest OWASP version for Application Gateways"


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
          "not":{
            "field": "Microsoft.Network/applicationGateways/firewallPolicy.id",
            "exists": "True"
          }
        },
        {
          "field": "Microsoft.Network/applicationGateways/webApplicationFirewallConfiguration.ruleSetVersion",
          "notIn":  "[parameters('allowedOWASPversion')]"
        }
      ]
    },
    "then": {
      "effect":  "[parameters('effect')]"
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

output "policydefinition_audit-agw-waf-ver" {
  value = azurerm_policy_definition.audit-agw-waf-ver
}