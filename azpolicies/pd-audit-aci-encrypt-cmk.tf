resource "azurerm_policy_definition" "audit-aci-encrypt-cmk" {
  name         = "audit-aci-encrypt-cmk"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Azure Container Instance container group must use customer-managed key for encryption"
  description  = "Secure your containers with greater flexibility using customer-managed keys. When you specify a customer-managed key, that key is used to protect and control access to the key that encrypts your data. Using customer-managed keys provides additional capabilities to control rotation of the key encryption key or cryptographically erase data."

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ACI-CTRL-22, AZR-ACI-CTRL-28",
    "fim-12-ctrl": "DSEC.2, DSEC.4",
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
                "field": "Microsoft.ContainerInstance/containerGroups/encryptionProperties.vaultBaseUrl",
                "exists": false
              },
              {
                "field": "Microsoft.ContainerInstance/containerGroups/encryptionProperties.keyName",
                "exists": false
              }
            ]
          }
        ]
    },
    "then": {
    "effect": "Audit"
  }
 }
POLICY_RULE
}

output "policydefinition_audit-aci-encrypt-cmk" {
  value = azurerm_policy_definition.audit-aci-encrypt-cmk
}