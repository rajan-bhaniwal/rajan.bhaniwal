resource "azurerm_policy_definition" "audit-purview-pvl" {
  name         = "audit-purview-pvl"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Purview accounts must use private link"
  description  = "Azure Private Link lets you connect your virtual network to Azure services without a public IP address at the source or destination. The private link platform handles the connectivity between the consumer and services over the Azure backbone network. By mapping private endpoints to your Azure Purview accounts instead of the entire service, you'll also be protected against data leakage risks. Learn more at: https://aka.ms/purview-private-link."


  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-PV-CTRL-04, AZR-PV-CTRL-05, AZR-PV-CTRL-06, AZR-PV-CTRL-11",
    "fim-l2-ctrl": "NSEC.1",
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
          "equals": "Microsoft.Purview/accounts"
        },
        {
          "count": {
            "field": "Microsoft.Purview/accounts/privateEndpointConnections[*]",
            "where": {
              "field": "Microsoft.Purview/accounts/privateEndpointConnections[*].privateLinkServiceConnectionState.status",
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

output "policydefinition_audit-purview-pvl" {
  value = azurerm_policy_definition.audit-purview-pvl
}