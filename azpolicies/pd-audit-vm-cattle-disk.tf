resource "azurerm_policy_definition" "pd-audit-vm-cattle-disk" {
  name         = "pd-audit-vm-cattle-disk"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Cattle Virtual Machines must not be deployed with Data Disks"
  description  = "Audit Cattle Virtual Machines must not be deployed with Data Disks" 

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-VMLC-CTRL-32,AZR-VMWC-CTRL-32",
    "fim-12-ctrl": "ITOP2,ITOP6,ITAM.1,ITAM.3,ITAM.4,PROT.2,DSEC.4,DSEC.5",
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
            },
            {
                  "field":"[concat('tags[', 'VM Type', ']')]",
                  "Like": "Cattle"
            },
            {
              "value": "[length(field('Microsoft.Compute/virtualMachines/storageProfile.dataDisks'))]",
              "greater": 0
            }
        ]
    },
      "then": {
        "effect": "audit"
      }
  }
POLICY_RULE
}

output "policydefinition_pd-audit-vm-cattle-disk" {
  value = azurerm_policy_definition.pd-audit-vm-cattle-disk
}