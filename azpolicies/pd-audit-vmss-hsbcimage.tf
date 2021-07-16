resource "azurerm_policy_definition" "pd-audit-vmss-hsbcimage" {
  name         = "pd-audit-vmss-hsbcimage"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Virtual Machines Scale Set must not use market place images"
  description  = "Audit Virtual Machines Scale Set must be deployed using approved ITID OS Image" 

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-VMLP-CTRL-10,11,AZR-VMLC-CTRL-09,15,AZR-VMWC-CTRL-55,13,14,AZR-VMWP-CTRL-01,18,21",
    "fim-12-ctrl": "ARCH.2,DEPL.3,ITOP2,ITOP6,VULN.1,PROT.2,SECA.1",
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
              "equals": "Microsoft.Compute/VirtualMachineScaleSets"
            },
            {
              "field": "Microsoft.Compute/virtualMachineScaleSets/virtualMachineProfile.storageProfile.imageReference.id",
              "exists": "false"
            }
        ]
    },
      "then": {
        "effect": "audit"
      }
  }
POLICY_RULE
}

output "policydefinition_pd-audit-vmss-hsbcimage" {
  value = azurerm_policy_definition.pd-audit-vmss-hsbcimage
}