resource "azurerm_policy_definition" "pd-audit-vmss-typetags" {
  name         = "pd-audit-vmss-typetags"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Virtual Machines scaleset must be deployed with VM Type Tags"
  description  = "Audit Virtual Machines scaleset must be deployed with VM Type Tags with value of Pet or Cattle" 

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-VMLP-CTRL-13|AZR-VMLC-CTRL-44",
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
              "equals": "Microsoft.Compute/VirtualMachineScaleSets"
            }
        ]
    },
      "then": {
        "effect": "auditIfNotExists",
        "details": {
          "type": "Microsoft.Compute/VirtualMachineScaleSets",
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

output "policydefinition_pd-audit-vmss-typetags" {
  value = azurerm_policy_definition.pd-audit-vmss-typetags
}