resource "azurerm_policy_definition" "pd-audit-vm-mdisk" {
  name         = "pd-audit-vm-mdisk"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Pet and Cattle Virtual Machines must be deployed with Azure Managed Disks"
  description  = "Audit Pet and Cattle Virtual Machines must be deployed with Azure Managed Disks" 

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-VMLP-CTRL-13|AZR-VMLC-CTRL-27,30|AZR-VMWP-CTRL-50|AZR-VMWC-CTRL-10,38,40",
    "fim-12-ctrl": "ITOP.3,ITOP6,PROT.2,ITAM.4,ITOP2,ITAM.3,DSEC.4,DSEC.5",
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
              "field": "Microsoft.Compute/virtualMachines/osDisk.uri",
              "exists": "true"
            }
        ]
    },
      "then": {
        "effect": "audit"
      }
  }
POLICY_RULE
}

output "policydefinition_pd-audit-vm-mdisk" {
  value = azurerm_policy_definition.pd-audit-vm-mdisk
}