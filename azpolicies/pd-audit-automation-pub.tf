resource "azurerm_policy_definition" "audit-automation-pub" {
  name         = "audit-automation-pub"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Automation accounts must disable public network access"
  description = "Disabling public network access improves security by ensuring that the resource isn't exposed on the public internet. You can limit exposure of your Automation account resources by creating private endpoints instead."

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-AA-CTRL-14",
    "fim-12-ctrl": "NSEC.1",
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
            "equals": "Microsoft.Automation/automationAccounts"
          },
          {
            "field": "Microsoft.Automation/automationAccounts/publicNetworkAccess",
            "notEquals": "false"
          }
        ]
    },
    "then": {
    "effect": "Audit"
  }
 }
POLICY_RULE
}

output "policydefinition_audit-automation-pub" {
  value = azurerm_policy_definition.audit-automation-pub
}