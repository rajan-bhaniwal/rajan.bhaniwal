resource "azurerm_policy_definition" "deploy-sub-defender-str" {
  name         = "deploy-sub-defender-str"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Enable ASC Defender standard tier for Storage Accounts"
  description  = "Enable Azure Security Center Defender standard tier for Storage Accounts"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "Azsk",
    "fim-12-ctrl": "LOGM.1,LOGM.2,LOGM.3,ITAM.3,ITOP.2",
    "priority": "P2",
    "source" : "Azsk",
    "exclude-reporting": "true",
    "exclude-from-alerts": "true"
    }

METADATA


  policy_rule = <<POLICY_RULE
    {
      "if": {
        "field": "type",
        "equals": "Microsoft.Resources/subscriptions"
  },
  "then": {
    "effect": "deployIfNotExists",
    "details": {
      "type": "Microsoft.Security/pricings",
      "name": "StorageAccounts",
      "deploymentScope": "subscription",
      "existenceScope": "subscription",
      "roleDefinitionIds": [
        "/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
      ],
      "existenceCondition": {        
            "field": "Microsoft.Security/pricings/pricingTier",
            "equals": "Standard"
      },
      "deployment": {
          "location": "westeurope",
          "properties": {
              "mode": "incremental",
              "template": {
                  "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "variables": {},
                  "resources": [
                      {
                          "type": "Microsoft.Security/pricings",
                          "apiVersion": "2018-06-01",
                          "name": "StorageAccounts",
                          "properties":{
                              "pricingTier": "Standard"
                          }
                      }
                  ],
                  "outputs": {}
                }
            }
          }
        }
    }
  }
POLICY_RULE
}

output "policydefinition_deploy-sub-defender-str" {
  value = azurerm_policy_definition.deploy-sub-defender-str
}