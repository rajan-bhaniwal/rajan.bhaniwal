resource "azurerm_policy_definition" "audit-acrencrypt-cmk" {
  name         = "audit-acrencrypt-cmk"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Container registries must be encrypted with a customer-managed key"
  description  = "Use customer-managed keys to manage the encryption at rest of the contents of your registries. By default, the data is encrypted at rest with service-managed keys, but customer-managed keys are commonly required to meet regulatory compliance standards. Customer-managed keys enable the data to be encrypted with an Azure Key Vault key created and owned by you. You have full control and responsibility for the key lifecycle, including rotation and management. Learn more at https://aka.ms/acr/CMK."

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ACR-CTRL-10",
    "fim-12-ctrl": "DSEC.4",
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
            "equals": "Microsoft.ContainerRegistry/registries"
          },
          {
            "field": "Microsoft.ContainerRegistry/registries/encryption.status",
            "notEquals": "enabled"
          }
        ]
    },
    "then": {
    "effect": "Audit"
  }
 }
POLICY_RULE
}

output "policydefinition_audit-acrencrypt-cmk" {
  value = azurerm_policy_definition.audit-acrencrypt-cmk
}