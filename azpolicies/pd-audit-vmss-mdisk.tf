resource "azurerm_policy_definition" "pd-audit-vmss-mdisk" {
  name         = "pd-audit-vmss-mdisk"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Virtual Machines Scale Set must be deployed with Azure Managed Disks"
  description  = "Audit Virtual Machines Scale Set must be deployed with Azure Managed Disks" 

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-VMLP-CTRL-13|AZR-VMLC-CTRL-27,30",
    "fim-12-ctrl": "ITOP.3,ITOP6,PROT.2,ITAM.4,ITOP2,ITAM.3",
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
            }
        ]
    },
      "then": {
        "effect": "auditIfNotExists",
        "details": {
          "type": "Microsoft.Compute/virtualMachineScaleSets",
          "existenceCondition": {
           "anyOf": [
              {
                "field": "Microsoft.Compute/VirtualMachineScaleSets/osDisk.vhdContainers",
                "exists": "False"
              },
              {
                "field": "Microsoft.Compute/VirtualMachineScaleSets/osdisk.imageUrl",
                "exists": "False"
              }
           ]
          }
        }
      }
  }
POLICY_RULE
}

output "policydefinition_pd-audit-vmss-mdisk" {
  value = azurerm_policy_definition.pd-audit-vmss-mdisk
}