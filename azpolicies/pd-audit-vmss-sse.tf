resource "azurerm_policy_definition" "pd-audit-vmss-sse" {
  name         = "pd-audit-vmss-sse"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Prod Virtual Machines Scaleset must be deployed with Encyption at host, ADE must not be used."
  description  = "Use encryption at host to get end-to-end encryption for your virtual machine for supported resgion, Azure Disk encyption (ADE) must not be used." 

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-VMLP-CTRL-27|AZR-VMLC-CTRL-57",
    "fim-12-ctrl": "DSEC.4,DSEC.5",
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
              "equals": "Microsoft.Compute/virtualMachineScaleSets"
            },
            {
              "field": "Microsoft.Compute/virtualMachineScaleSets/virtualMachineProfile.securityProfile.encryptionAtHost",
              "notEquals": "true"
            },
            {
            "not": {
                  "field":"[concat('tags[', parameters('tagName'), ']')]",
                  "equals": "[parameters('tagValue')]"
                }
            }
        ]
    },
      "then": {
        "effect": "audit"
      }
  }
POLICY_RULE
  parameters = <<PARAMETERS
  {
    "tagName": {
    "type": "String",
    "metadata": {
        "displayName": "Tag Name",
        "decription": "Name of the tag, such as 'environment'"
      },
    "defaultValue": ""
    },
    "tagValue": {
    "type": "String",
    "metadata": {
        "displayName": "Tag Value",
        "decription": "Tag Value, such as 'Yes or No'"
      },
      "defaultValue": ""
    }
  }
PARAMETERS
}

output "policydefinition_pd-audit-vmss-sse" {
  value = azurerm_policy_definition.pd-audit-vmss-sse
}