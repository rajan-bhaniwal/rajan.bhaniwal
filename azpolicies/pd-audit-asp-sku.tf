resource "azurerm_policy_definition" "audit-asp-sku" {
  name         = "audit-asp-sku"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit App Service Plan must use approved sku premium, isolated or dedicated only"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-FN-CTRL-23,AZR-ASW-CTRL-01",
    "fim-12-ctrl": "",
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
          "equals": "Microsoft.Web/serverfarms"
        },
        {
        "anyOf": [
            {
              "field":"[concat('tags[', 'Data Classification', ']')]",
              "like": "Highly Restricted"
            },
            {
              "field":"[concat('tags[', 'Data Classification', ']')]",
              "like": "Restricted"
            }
          ]
        }
      ]
    },
    "then": {
      "effect": "AuditIfNotExists",
      "details": {
        "type": "Microsoft.Web/serverfarms",
        "existenceCondition": {
        "anyOf": [          
            {
              "field": "Microsoft.Web/serverfarms/sku.tier",
              "like": "Premium*"
            },
            {
              "field": "Microsoft.Web/serverfarms/sku.tier",
              "like": "Isolated*"
            },
            {
              "field": "Microsoft.Web/serverfarms/sku.tier",
              "like": "Dedicated*"
            }
          ]            
        }
      }
    }
  }
POLICY_RULE
}

output "policydefinition_audit-asp-sku" {
  value = azurerm_policy_definition.audit-asp-sku
}