resource "azurerm_policy_definition" "pd-audit-vm-pet-dmz" {
  name         = "pd-audit-vm-pet-dmz"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Pet Virtual Machines must not be deployed in DMZ sidecar network"
  description  = "Audit Pet Virtual Machines must not be deployed in DMZ sidecar network" 

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-VMLP-CTRL-32",
    "fim-12-ctrl": "NSEC.1",
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
            "equals": "Microsoft.Network/networkInterfaces"
          },
          {
            "allOf": [
              {
                    "field":"[concat('tags[', 'VM Type', ']')]",
                    "Like": "Pet"
              },
              {

                  "field": "Microsoft.Network/networkInterfaces/ipconfigurations[*].subnet.id",
                  "contains": "[parameters('DMZvNetName')]"
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

  parameters = <<PARAMETERS
  {
    "DMZvNetName": {
    "type": "String",
    "metadata": {
        "displayName": "Provide DMZ vNET name",
        "decription": "Provide DMZ vNET name"
      },
    "defaultValue": "sidecar-vnet"
    }
  }
PARAMETERS

}

output "policydefinition_pd-audit-vm-pet-dmz" {
  value = azurerm_policy_definition.pd-audit-vm-pet-dmz
}