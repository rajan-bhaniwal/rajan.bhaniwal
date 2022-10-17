resource "azurerm_policy_definition" "audit-disk-createoption" {
  name         = "audit-disk-createoption"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Disk should be provisioned from ITID image, uploading disks are not allowed."
  description  = "Disk should be provisioned from ITID image, uploading disks are not allowed."


  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ALL-CTRL-34",
    "fim-l2-ctrl": "LOGM.1, LOGM.2, LOGM.3, DSEC.2",
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
          "equals": "Microsoft.Compute/disks"
        },
        {
          "field": "Microsoft.Compute/disks/creationData.createOption",
          "contains":  "Upload"
        }
      ]
    },
    "then": {
      "effect":  "[parameters('effect')]"
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
        "Audit",
        "Deny",
        "Disabled"
      ],
      "defaultValue": "Audit"
    }
  }
PARAMETERS

}

output "policydefinition_audit-disk-createoption" {
  value = azurerm_policy_definition.audit-disk-createoption
}