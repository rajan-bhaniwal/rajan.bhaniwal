resource "azurerm_policy_definition" "pd-audit-vm-oms-lnx" {
  name         = "pd-audit-vm-oms-lnx"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Linux Pet and Cattle Virtual Machines must be deployed with Log Analytics monitoring Extension"
  description  = "Audit Linux Pet and Cattle Virtual Machines must be deployed with Log Analytics monitoring Extension" 

  management_group_name = var.root_management_group_name
 
  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-VMLP-CTRL-14,16|AZR-VMLC-CTRL-11",
    "fim-12-ctrl": "SDLC1, SECA.1,PROT.2,ITAM.4,ITOP2,VULN.1",
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
            }
        ]
    },
      "then": {
        "effect": "auditIfNotExists",
        "details": {
          "type": "Microsoft.Compute/virtualMachines/extensions",
          "existenceCondition": {
           "allOf": [
              {
                "field": "Microsoft.Compute/virtualMachines/extensions/type",
                "equals": "OmsAgentForLinux"
              },
              {
                  "field": "Microsoft.Compute/virtualMachines/extensions/provisioningState",
                  "equals": "Succeeded"
              }
           ]
          }
        }
      }
  }
POLICY_RULE
}

output "policydefinition_pd-audit-vm-oms-lnx" {
  value = azurerm_policy_definition.pd-audit-vm-oms-lnx
}