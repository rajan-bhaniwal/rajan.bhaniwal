resource "azurerm_policy_definition" "audit-cattle-vm-age" {
  name         = "audit-cattle-vm-age"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure virtual machines using cattle image must be re-created every 45 Days"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-VM-CTRL-36",
    "fim-12-ctrl": "",
    "priority": "P1",
    "source" : "",
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
                "field":"[concat('tags[', 'VM Type', ']')]",
                "exists": "true"
            },
            {
                "field":"[concat('tags[', 'Recycle Date', ']')]",
                "exists": "true"
            },
            {
              "field":"[concat('tags[', 'VM Type', ']')]",
              "like": "Cattle"
            }                       
        ]
      },
      "then": {
        "effect": "auditIfNotExists",
        "details": {
          "type": "Microsoft.Compute/virtualMachines",
          "existenceCondition": {
              "value": "[field(concat('tags[', 'Recycle Date', ']'))]",
              "greater": "[utcNow()]"
          }
        }
      }
  }
POLICY_RULE
}

output "policydefinition_audit-cattle-vm-age" {
  value = azurerm_policy_definition.audit-cattle-vm-age
}