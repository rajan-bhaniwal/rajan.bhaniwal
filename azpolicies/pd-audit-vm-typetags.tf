resource "azurerm_policy_definition" "pd-audit-vm-typetags" {
  name         = "pd-audit-vm-typetags"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Pet and Cattle Virtual Machines must be deployed with 'VM Type' Tag"
  description  = "Audit Pet and Cattle Virtual Machines must be deployed with 'VM Type' Tag with value of Pet or Cattle" 

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-VMLP-CTRL-13|AZR-VMLC-CTRL-44|AZR-VMWP-CTRL-22|AZR-VMWC-CTRL-53",
    "fim-12-ctrl": "ITOP6,PROT.2,ITAM.4,ITOP2,ITAM-IT",
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
           "allOf": [
              {
                "field":"[concat('tags[', 'VM Type', ']')]",
                "exists": "True"
              },
              {
              "anyOf": [
                  {
                    "field":"[concat('tags[', 'VM Type', ']')]",
                    "like": "Pet"
                  },
                  {
                    "field":"[concat('tags[', 'VM Type', ']')]",
                    "Like": "Cattle"
                  }
                ]
              }
           ]
          }
        }
      }
  }
POLICY_RULE
}

output "policydefinition_pd-audit-vm-typetags" {
  value = azurerm_policy_definition.pd-audit-vm-typetags
}