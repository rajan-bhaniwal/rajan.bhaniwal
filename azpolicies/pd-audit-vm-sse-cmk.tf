resource "azurerm_policy_definition" "pd-audit-vm-sse-cmk-lnx" {
  name         = "pd-audit-vm-sse-cmk-lnx"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Pet and Cattle Virtual Machines with data classification Restricted or Higher must have SSE+CMK encryption enabled."
  description  = "Use encryption at host to get end-to-end encryption with customer managed keys for virtual machine with data classification Restricted, Azure Disk encyption (ADE) must not be used." 

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-VMLP-CTRL-27|AZR-VMLC-CTRL-57",
    "fim-12-ctrl": "DSEC.4,DSEC.5",
    "priority": "P2",
    "source" : "",
    "exclude-reporting": "true",
    "exclude-from-alerts": "true"
    }

METADATA


  policy_rule = <<POLICY_RULE
  {
    "if": {
        "anyOf": [
          {
            "allOf": [
                {
                  "field": "type",
                  "equals": "Microsoft.Compute/virtualMachines"
                },
                {
                  "field": "Microsoft.Compute/virtualMachines/storageProfile.osDisk.managedDisk.diskEncryptionSet.id",
                  "exists": "false"
                },
                {
                  "not":
                      {
                        "anyOf": [
                            {
                              "field":"[concat('tags[', 'Data Classification', ']')]",
                              "like": "Public"
                            },
                            {
                              "field":"[concat('tags[', 'Data Classification', ']')]",
                              "like": "Internal"
                            }
                          ]
                      }
                }
             ]
          },
          {
            "allOf": [
              {
                "field": "type",
                "equals": "Microsoft.Compute/virtualMachines"
              },
              {
                "value": "[length(field('Microsoft.Compute/virtualMachines/storageProfile.dataDisks'))]",
                "greater": 0
              },
              {
                "field": "Microsoft.Compute/virtualMachines/storageProfile.dataDisks[*].managedDisk.id",
                "exists": "false"
              },
              {
                "field": "Microsoft.Compute/virtualMachines/storageProfile.dataDisks[*].managedDisk.diskEncryptionSet.id",
                "exists": "false"
              },
              {
                "not":
                    {
                      "anyOf": [
                          {
                            "field":"[concat('tags[', 'Data Classification', ']')]",
                            "like": "Public"
                          },
                          {
                            "field":"[concat('tags[', 'Data Classification', ']')]",
                            "like": "Internal"
                          }
                        ]
                    }
              }
            ]
          }
      ]
    },
      "then": {
        "effect": "audit"
      }
  }
POLICY_RULE
}

output "policydefinition_pd-audit-vm-sse-cmk-lnx" {
  value = azurerm_policy_definition.pd-audit-vm-sse-cmk-lnx
}