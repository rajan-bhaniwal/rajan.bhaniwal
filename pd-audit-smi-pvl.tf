resource "azurerm_policy_definition" "audit-smi-pvl" {
  name         = "audit-smi-pvl"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure SQL Managed Instance must have Private Endpoint enabled"
  description  = "This policy audits Azure SQL Managed Instance Private Endpoint connection. Private endpoint connections enforce secure communication."
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
            "count": {
              "field": "Microsoft.Sql/managedInstances/privateEndpointConnections[*]",
              "where": {
                "field": "Microsoft.Sql/managedInstances/privateEndpointConnections[*].privateLinkServiceConnectionState.status",
                "equals": "Approved"
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
      }
  }
PARAMETERS

}

output "policydefinition_audit-smi-pvl" {
  value = azurerm_policy_definition.audit-smi-pvl
}