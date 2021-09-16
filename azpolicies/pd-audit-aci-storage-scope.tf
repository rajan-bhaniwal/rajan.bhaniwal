resource "azurerm_policy_definition" "audit-aci-storage-scope" {
  name         = "audit-aci-storage-scope"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Container group file share Storage account encryption must use customer-managed keys to encrypt data at rest"
  description  = "Use customer-managed keys to manage the encryption at rest of your storage account encryption scopes. Customer-managed keys enable the data to be encrypted with an Azure key-vault key created and owned by you."

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ACI-CTRL-37",
    "fim-12-ctrl": "DSEC.5",
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
            "equals": "Microsoft.ContainerInstance/containerGroups"
          },
          {
            "anyOf": [
              {
                "field": "Microsoft.ContainerInstance/containerGroups/volumes[*].azureFile.shareName",
                "exists": true
              },
              {
                "field": "Microsoft.ContainerInstance/containerGroups/volumes[*].azureFile.storageAccountName",
                "exists": true
              }
            ]
          }
        ]
    },
    "then": {
      "effect": "AuditIfNotExists",
      "details": {
        "type": "Microsoft.Storage/storageAccounts/encryptionScopes",
        "name": "[string(field('Microsoft.ContainerInstance/containerGroups/volumes[*].azureFile.storageAccountName'))]",
        "existenceCondition": {
        "allOf": [          
            {
              "field": "Microsoft.Storage/storageAccounts/encryptionScopes/source",
              "equals": "Microsoft.Keyvault"
            }
          ]            
        }
      }
    }
  }
POLICY_RULE
}

output "policydefinition_audit-aci-storage-scope" {
  value = azurerm_policy_definition.audit-aci-storage-scope
}