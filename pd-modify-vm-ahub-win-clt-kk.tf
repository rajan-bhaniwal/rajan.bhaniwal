resource "azurerm_policy_definition" "modify-vm-ahub-win-clt" {
  name         = "modify-vm-ahub-win-clt"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Modify - Windows Client Virtual Machines should be deployed with Azure Hybrid Use Benefit"
  description  = "Windows Virtual Machines should be deployed with Azure Hybrid Use Benefit https://docs.microsoft.com/en-us/azure/virtual-machines/windows/hybrid-use-benefit-licensing"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "Governance",
    "fim-12-ctrl": "Governance",
    "priority": "P2",
    "source" : "Governance",
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
              "value":"[resourcegroup().tags[parameters('tagName')]]",
              "equals": "[parameters('tagValue')]"
            },
            {
              "value": "[resourcegroup().name]",
              "contains": "[parameters('clientResourceGroupNameContains')]"
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
              "anyOf": [
                {
                  "value": "[field('Microsoft.Compute/virtualMachines/licenseType')]",
                  "exists": "false"          
                },
                {
                  "value": "[field('Microsoft.Compute/virtualMachines/licenseType')]",
                  "notIn": ["Windows_Server", "Windows_Client"]          
                }
              ]
            }
        ]
    },
  "then": {
    "effect": "[parameters('effect')]",
    "details": {
      "roleDefinitionIds": [
        "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
      ],
      "conflictEffect": "audit",
      "operations": [{
          "condition": "[greaterOrEquals(requestContext().apiVersion, '2021-11-01')]",
          "operation": "addOrReplace",
          "field": "Microsoft.Compute/virtualMachines/licenseType",
          "value": "[parameters('licenseType')]"
      }]
    }
  }
}
POLICY_RULE
  parameters = <<PARAMETERS
  {
    "effect": {
      "type": "String",
      "metadata": {
        "displayName": "Effect",
        "description": "Enable or disable the execution of the policy"
      },
      "allowedValues": [
        "Modify",
        "Disabled"
      ],
      "defaultValue": "Modify"
    },
    "licenseType": {
      "type": "String",
      "allowedValues": [
        "Windows_Client"
      ],
      "defaultValue": "Windows_Client"
    },
    "tagName": {
    "type": "String",
    "metadata": {
        "displayName": "Tag Name",
        "decription": "Name of the tag, such as 'environment'"
      }
    },
    "tagValue": {
    "type": "String",
    "metadata": {
        "displayName": "Tag Value",
        "decription": "Tag Value, such as 'Yes or No'"
      }
    },
    "clientResourceGroupNameContains": {
    "type": "String",
    "metadata": {
        "displayName": "Resourcegroup name filter for client vms.",
        "decription": "Resourcegroup name filter for client vms."
      }
    }   
  }
PARAMETERS
}

output "policydefinition_modify-vm-ahub-win-clt" {
  value = azurerm_policy_definition.modify-vm-ahub-win-clt
}