resource "azurerm_policy_definition" "audit-frontdoor-waf" {
  name         = "audit-frontdoor-waf"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit - Azure Web Application Firewall should be enabled for Azure Front Door entry-points"
  description  = "Audit - Azure Web Application Firewall (WAF) in front of public facing web applications for additional inspection of incoming traffic. Web Application Firewall (WAF) provides centralized protection of your web applications from common exploits and vulnerabilities such as SQL injections, Cross-Site Scripting, local and remote file executions. You can also restrict access to your web applications by countries, IP address ranges, and other http(s) parameters via custom rules."


  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ALL-CTRL-13",
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
      "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Network/frontdoors"
          },
          {
            "field": "Microsoft.Network/frontdoors/frontendEndpoints[*].webApplicationFirewallPolicyLink.id",
            "exists": "false"
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
    }
  }
PARAMETERS

}

output "policydefinition_audit-frontdoor-waf" {
  value = azurerm_policy_definition.audit-frontdoor-waf
}