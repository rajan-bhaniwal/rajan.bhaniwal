resource "azurerm_policy_definition" "audit-cdn-sku" {
  name         = "audit-cdn-sku"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure CDN profiles must only use Azure Native profiles that support Domain Fronting protection."
  description  = "Azure CDN profiles must only use Azure Native profiles that support Domain Fronting protection."


  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-CDN-CTRL-29, AZR-CDN-CTRL-31",
    "fim-l2-ctrl": "NSEC.5, ITOP.2",
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
            "equals": "Microsoft.Cdn/Profiles"
          },
          {
            "field": "Microsoft.Cdn/Profiles/sku.name",
            "notIn": "[parameters('approvedSKU')]"
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
    },
    "approvedSKU": {
      "type": "Array",
      "metadata": {
        "displayName": "List of approved SKUs",
        "description": "List of approved SKUs"
      },
      "defaultValue": [
      "Premium_AzureFrontDoor",
      "Standard_Akamai",
      "Standard_AzureFrontDoor",
      "Standard_Microsoft"
      ]
    }
  }
PARAMETERS

}

output "policydefinition_audit-cdn-sku" {
  value = azurerm_policy_definition.audit-cdn-sku
}