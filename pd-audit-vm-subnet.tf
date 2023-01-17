resource "azurerm_policy_definition" "audit-vm-subnet" {
  name         = "audit-vm-subnet"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Virtual Machine is not allowed in this subnets."
  description  = "Azure Virtual Machine is not allowed in this subnets."



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
          "equals": "Microsoft.Network/networkInterfaces",
          "field": "type"
        },
        {
          "exists": "true",
          "field": "Microsoft.Network/networkInterfaces/virtualMachine.id"
        },
        {
          "count": {
            "field": "Microsoft.Network/networkInterfaces/ipconfigurations[*]",
            "where": {
              "count": {
                "name": "pattern",
                "value": "[parameters('disallowedSubnet')]",
                "where": {
                  "contains": "[current('pattern')]",
                  "field": "Microsoft.Network/networkInterfaces/ipconfigurations[*].subnet.id"
                }
              },
              "greater": 0
            }
          },
          "greater": 0
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
    "disallowedSubnet": {
        "type": "Array",
        "metadata": {
            "displayName": "Name of subnet where Virtual Machine is not allowed to deploy."
        },
        "defaultValue": [
          "AzureBastionSubnet",
          "AzureFirewallSubnet",
          "AzureFirewallManagementSubnet",
          "GatewaySubnet",
          "AppGateway",
          "AGW",
          "ApplicationGateway",
          "privateendpoint",
          "-pe-"
        ]
    }            
  }
PARAMETERS
}

output "policydefinition_audit-vm-subnet" {
  value = azurerm_policy_definition.audit-vm-subnet
}