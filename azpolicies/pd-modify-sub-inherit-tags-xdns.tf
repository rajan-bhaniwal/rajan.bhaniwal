resource "azurerm_policy_definition" "modify-sub-inherit-tags-xdns" {
  name         = "modify-sub-inherit-tags-xdns"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Inherit tags from subscription excluding Azure Private DNS zones"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "24",
    "fim-12-ctrl": "",
    "priority": "P2",
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
                "field": "[concat('tags[', parameters('tagName'), ']')]",
                "notEquals": "[subscription().tags[parameters('tagName')]]"
            },
            {
                "value": "[subscription().tags[parameters('tagName')]]",
                "notEquals": ""
            },
            {
              "not": {
                  "anyOf": [
                      {
                        "field":"type",
                        "equals": "Microsoft.Network/privateDnsZones"
                      },
                      {
                        "field":"type",
                        "equals": "Microsoft.Network/privateDnsZones/virtualNetworkLinks"
                      },
                      {
                        "field":"type",
                        "equals": "Microsoft.Network/privateEndpoints/privateDnsZoneGroups"
                      }
                  ]
              }
            }
      ]
  },
  "then": {
    "effect": "modify",
    "details": {
      "roleDefinitionIds": [
        "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
      ],
      "conflictEffect": "audit",
      "operations": [{
          "operation": "addOrReplace",
          "field": "[concat('tags[', parameters('tagName'), ']')]",
          "value": "[subscription().tags[parameters('tagName')]]"
      }]
    }
  }
}
POLICY_RULE

  parameters = <<PARAMETERS
  {
    "tagname": {
    "type": "String",
    "metadata": {
        "displayName": "Tag Name",
        "decription": "Name of the tag, such as 'environment'"
      }
    }
  }
PARAMETERS

}


output "policydefinition_modify-sub-inherit-tags-xdns" {
  value = azurerm_policy_definition.modify-sub-inherit-tags-xdns
}