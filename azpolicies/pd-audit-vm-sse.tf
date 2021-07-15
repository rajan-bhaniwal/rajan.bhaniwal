resource "azurerm_policy_definition" "pd-audit-vm-sse" {
  name         = "pd-audit-vm-sse"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit production Pet and Cattle Virtual Machines must be deployed with Encyption at host, ADE must not be used."
  description  = "Use encryption at host to get end-to-end encryption for your virtual machine for supported regions, Azure Disk encyption (ADE) must not be used." 

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-VMLP-CTRL-27|AZR-VMLC-CTRL-57|AZR-VMWP-CTRL-50|AZR-VMWC-CTRL-40",
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
              "equals": "Microsoft.Compute/virtualMachines"
            },
            {
              "not": {
                  "field":"[concat('tags[', parameters('tagName'), ']')]",
                  "equals": "[parameters('tagValue')]"
                }
            },
            {
              "anyOf": [
                {
                  "field": "Microsoft.Compute/virtualMachines/osProfile.linuxConfiguration",
                  "exists": "true"
                },
                {
                  "field": "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType",
                  "like": "Linux*"
                }
              ]
            },
            {
              "anyOf": [
                {
                  "field": "Microsoft.Compute/virtualMachines/osProfile.windowsConfiguration",
                  "exists": "true"
                },
                {
                  "field": "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType",
                  "like": "Windows*"
                }
              ]
            }
        ]
    },
      "then": {
        "effect": "auditIfNotExists",
        "details": {
          "type": "Microsoft.Compute/virtualMachines",
          "existenceCondition": {
            "field": "Microsoft.Compute/virtualMachines/securityProfile.encryptionAtHost",
            "equals": "true"
          }
        }
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
        "decription": "Tag value, such as 'Yes' or 'No'"
      },
      "defaultValue": ""
    }
  }
PARAMETERS

}

output "policydefinition_pd-audit-vm-sse" {
  value = azurerm_policy_definition.pd-audit-vm-sse
}