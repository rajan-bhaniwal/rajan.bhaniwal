resource "azurerm_policy_definition" "audit-asl-fn-client-cert" {
  name         = "audit-asl-fn-client-cert"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit - App Service apps should have 'Client Certificates (Incoming client certificates)' enabled"
  description  = "Client certificates allow for the app to request a certificate for incoming requests. Only clients that have a valid certificate will be able to reach the app."

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-FN-CTRL-12,AZR-ASW-CTRL-08,AZR-ASL-CTRL-08,AZR-BOT-CTRL-06",
    "fim-12-ctrl": "IDAM.4",
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
            "equals": "Microsoft.Web/sites"
        }
      ]
    },
    "then": {
      "effect": "[parameters('effect')]",
      "details": {
          "type": "Microsoft.Web/sites/config",
          "name": "web",
          "existenceCondition": {
            "field": "Microsoft.Web/sites/config/siteAuthEnabled",
            "equals": "true"           
        }
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
          "AuditIfNotExists",
          "Disabled"
        ],
        "defaultValue": "AuditIfNotExists"
      }
  }
PARAMETERS

}

output "policydefinition_audit-asl-fn-client-cert" {
  value = azurerm_policy_definition.audit-asl-fn-client-cert
}