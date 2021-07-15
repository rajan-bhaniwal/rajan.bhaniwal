resource "azurerm_policy_definition" "pd-audit-vm-hsbcimage" {
  name         = "pd-audit-vm-hsbcimage"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Pet and Cattle Virtual Machines must not use market place images."
  description  = "Audit Pet and Cattle Virtual Machines must not use market place images and must use approved ITID OS Image" 

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-VMLP-CTRL-10,11,AZR-VMLC-CTRL-09,15,AZR-VMWC-CTRL-55,13,14,AZR-VMWP-CTRL-01,18,21",
    "fim-12-ctrl": "ARCH.2,DEPL.3,ITOP2,ITOP6,VULN.1,PROT.2,SECA.1",
    "priority": "P1",
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
            "field": "Microsoft.Compute/imageId",
            "contains": "[concat(subscription().id,'/resourcegroups/')]"
          }
        }
      }
  }
POLICY_RULE
}

output "policydefinition_pd-audit-vm-hsbcimage" {
  value = azurerm_policy_definition.pd-audit-vm-hsbcimage
}