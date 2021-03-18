resource "azurerm_policy_definition" "audit-storage-blob-softdelete" {
  name         = "audit-storage-blob-softdelete"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Storage Blob should be configured with softdelete, versioning and change feed"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "35",
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
        "not": {
                "field":"Microsoft.Storage/storageAccounts/isHnsEnabled",
                "equals": true
                }
        }
      ]
    },
    "then": {
        "effect": "auditIfNotExists",
        "details": {
          "type": "Microsoft.Storage/storageAccounts/blobServices",
          "existenceCondition": {
            "allOf": [
              {
                "field":"Microsoft.Storage/storageAccounts/blobServices/default.changeFeed.enabled",
                "equals": "true"
              },
              {
                "field":"Microsoft.Storage/storageAccounts/blobServices/default.isVersioningEnabled",
                "equals": "true"
              },
              {
                "field":"Microsoft.Storage/storageAccounts/blobServices/default.deleteRetentionPolicy.enabled",
                "equals": "true"
              }
            ]
          }
        }
    }
  }
POLICY_RULE
}

output "policydefinition_audit-storage-blob-softdelete" {
  value = azurerm_policy_definition.audit-storage-blob-softdelete
}