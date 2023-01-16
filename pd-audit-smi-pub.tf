resource "azurerm_policy_definition" "audit-smi-pub" {
  name         = "audit-smi-pub"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure SQL Managed Instances must disable public network access"
  description  = "This policy audits Azure SQL Managed Instance public network access. Disabling public network access (public endpoint) on Azure SQL Managed Instances improves security by ensuring that they can only be accessed from inside their virtual networks or via Private Endpoints. To learn more about public network access, visit https://aka.ms/mi-public-endpoint."
  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-SMI-CTRL-09",
    "fim-l2-ctrl": "DSEC.2, DMAN.3",
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
            "equals": "Microsoft.Sql/managedInstances"
          },
          {
            "field": "Microsoft.Sql/managedInstances/publicDataEndpointEnabled",
            "equals": true
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

output "policydefinition_audit-smi-pub" {
  value = azurerm_policy_definition.audit-smi-pub
}