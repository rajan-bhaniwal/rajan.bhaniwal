resource "azurerm_policy_definition" "audit-agw-subnet" {
  name         = "audit-agw-subnet"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Application Gateways are only allowed in approved subnets."
  description  = "Azure Application Gateways are only allowed in approved subnets."



  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "Governanace",
    "fim-l2-ctrl": "Governanace",
    "priority": "P2",
    "source" : "Governanace",
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
                    "field": "Microsoft.Network/applicationGateways/gatewayIPConfigurations[*].subnet.id",
                    "notContains": "[parameters('allowedSubnetName')]"
                }
            ]
    },
    "then": {
      "effect":  "[parameters('effect')]"
    }
  }
POLICY_RULE
  parameters = <<PARAMETERS
  {
 "effect": {
        "type": "String",
        "metadata": {
          "displayName": "Effect",
          "description": "The desired effect of the policy."
        },
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "defaultValue": "Audit"
      },
    "allowedSubnetName": {
        "type": "string",
        "metadata": {
            "displayName": "Name of subnet where Application Gateway is allowed to deploy."
        },
        "defaultValue": "AppGateway"
    }     
  }
PARAMETERS
}

output "policydefinition_audit-agw-subnet" {
  value = azurerm_policy_definition.audit-agw-subnet
}