resource "azurerm_policy_definition" "audit-eh-kafka" {
  name         = "audit-eh-kafka"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Event Hub Namespace with Data Classification of Restricted and Highly Restricted should use Apache Kafka protocol."
  description  = "This policy audits event hubs namespace with Data Classification of Restricted and Highly Restricted should use Apache Kafka protocol. https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-for-kafka-ecosystem-overview"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-EH-CTRL-32",
    "fim-l2-ctrl": "DSEC.6",
    "priority": "P3",
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
            "equals": "Microsoft.EventHub/namespaces"
          },
          {
            "allOf": [
              {
              "field":"[concat('tags[', 'Data Classification', ']')]",
              "exists": "true"
              },
              {
              "field":"[concat('tags[', 'Data Classification', ']')]",
              "in": "[parameters('dataClassification')]"
              }
            ]
          },          
          {
            "field": "Microsoft.EventHub/namespaces/kafkaEnabled",
            "notEquals": "true"
          }          
        ]
    },
    "then": {
      "effect": "[parameters('effect')]"
    }
  }
POLICY_RULE

  parameters = <<PARAMETERS
  {
     "effect": {
        "type": "String",
        "metadata": {
          "displayName": "Effect",
          "description": "The effect determines what happens when the policy rule is evaluated to match"
        },
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "defaultValue": "Audit"
      },
      "dataClassification": {
        "type": "Array",
        "metadata": {
          "displayName": "Data Classifictation",
          "description": "Data Classifictation Names to Apply"
        },
        "defaultValue": [
          "Restricted",
          "Highly Restricted"
        ]
      }      
  }
PARAMETERS

}

output "policydefinition_audit-eh-kafka" {
  value = azurerm_policy_definition.audit-eh-kafka
}