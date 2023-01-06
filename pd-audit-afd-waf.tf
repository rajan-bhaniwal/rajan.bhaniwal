resource "azurerm_policy_definition" "audit-afd-waf" {
  name         = "audit-afd-waf"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Web Application Firewall must be enabled for Azure Front Door entry-points"
  description  = "This policy audits Web Application Firewall for Azure Front Door entry-points. Azure Web Application Firewall (WAF) in front of public facing web applications for additional inspection of incoming traffic. Web Application Firewall (WAF) provides centralized protection of your web applications from common exploits and vulnerabilities such as SQL injections, Cross-Site Scripting, local and remote file executions. You can also restrict access to your web applications by countries, IP address ranges, and other http(s) parameters via custom rules."
  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-AFD-CTRL-20",
    "fim-l2-ctrl": "NSEC.1, DSEC.6",
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
          "description": "The effect determines what happens when the policy rule is evaluated to match"
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

output "policydefinition_audit-afd-waf" {
  value = azurerm_policy_definition.audit-afd-waf
}