resource "azurerm_policy_definition" "modify-storage-fw" {
  name         = "modify-storage-fw"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Modify and enable storage account firewall"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ABS-CTRL-21",
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
          "field": "type",
          "equals": "Microsoft.Storage/storageAccounts"
        },
        {
          "field":"[concat('tags[', parameters('tagName'), ']')]",
          "equals": "[parameters('tagValue')]"
        },
        {
          "anyOf" : [
            {
            "field": "Microsoft.Storage/storageAccounts/networkAcls.defaultAction",
            "notEquals": "Deny"
            }
          ]
        }
      ]
  },
  "then": {
    "effect": "modify",
    "details": {
      "roleDefinitionIds": [
        "/providers/Microsoft.Authorization/roleDefinitions/17d1049b-9a84-46fb-8f53-869881c3d3ab"
      ],
      "conflictEffect": "audit",
      "operations": [{
          "condition": "[greaterOrEquals(requestContext().apiVersion, '2018-11-09')]",
          "operation": "addOrReplace",
          "field": "Microsoft.Storage/storageAccounts/networkAcls.defaultAction",
          "value": "Deny"
      }]
    }
  }
}
POLICY_RULE

  parameters = <<PARAMETERS
  {
    "tagName": {
    "type": "String",
    "metadata": {
        "displayName": "Tag Name",
        "decription": "Name of the tag, such as 'environment'"
      }
    "defaultValue": ""
    },
    "tagValue": {
    "type": "String",
    "metadata": {
        "displayName": "Tag Value",
        "decription": "Name of the tag, such as 'environment'"
      },
      "defaultValue": ""
    }
  }
PARAMETERS

}

output "policydefinition_modify-storage-fw" {
  value = azurerm_policy_definition.modify-storage-fw
}