resource "azurerm_policy_definition" "audit-rsg-tag" {
  name         = "audit-rsg-tag"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Resource Group must have Production, BIA and Data Classification Tag assigned with values"
  description  = "Audit Resource Group must have Production, BIA and Data Classification Tag assigned with values"

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "",
    "fim-12-ctrl": "",
    "priority": "P3",
    "source" : "Governance",
    "exclude-reporting": "true",
    "exclude-from-alerts": "true"
    }

METADATA


  policy_rule = <<POLICY_RULE
    {
      "if": {
            "field": "type",
            "equals": "Microsoft.Resources/subscriptions/resourceGroups"
      },
      "then": {
        "effect": "auditIfNotExists",
        "details": {
          "type": "Microsoft.Resources/subscriptions/resourceGroups",
          "existenceCondition": {
                "allOf": [
                    {
                    "anyOf": [
                        {
                                "value": "[resourceGroup().tags['Production']]",
                                "like": "Yes"
                        },
                        {
                                "value": "[resourceGroup().tags['Production']]",
                                "like": "No"
                        }
                        ]
                    },
                    {
                    "anyOf": [
                        {
                                "value": "[resourceGroup().tags['Data Classification']]",
                                "like": "Public"
                        },
                        {
                                "value": "[resourceGroup().tags['Data Classification']]",
                                "like": "Internal"
                        },
                        {
                                "value": "[resourceGroup().tags['Data Classification']]",
                                "like": "Restricted"
                        },
                        {
                                "value": "[resourceGroup().tags['Data Classification']]",
                                "like": "Highly Restricted"
                        }
                        ]
                    },
                    {
                    "anyOf": [
                        {
                                "value": "[resourceGroup().tags['BIA']]",
                                "like": "Extreme"
                        },
                        {
                                "value": "[resourceGroup().tags['BIA']]",
                                "like": "Major"
                        },
                        {
                                "value": "[resourceGroup().tags['BIA']]",
                                "like": "Moderate"
                        },
                        {
                                "value": "[resourceGroup().tags['BIA']]",
                                "like": "Minor"
                        }
                        ]
                    },
                    {
                    "field": "[concat('tags[', 'Application Name', ']')]",
                    "exists": "true"
                    },
                    {
                    "field": "[concat('tags[', 'BPID', ']')]",
                    "exists": "true"
                    },
                    {
                    "field": "[concat('tags[', 'Clarity Project', ']')]",
                    "exists": "true"
                    },
                    {
                    "field": "[concat('tags[', 'Comet ID', ']')]",
                    "exists": "true"
                    },
                    {
                    "field": "[concat('tags[', 'EHC ID', ']')]",
                    "exists": "true"
                    },
                    {
                    "field": "[concat('tags[', 'EIM', ']')]",
                    "exists": "true"
                    },
                    {
                    "field": "[concat('tags[', 'EIM Status', ']')]",
                    "exists": "true"
                    },
                    {
                    "field": "[concat('tags[', 'GBGF', ']')]",
                    "exists": "true"
                    },
                    {
                    "field": "[concat('tags[', 'ITSO', ']')]",
                    "exists": "true"
                    },
                    {
                    "field": "[concat('tags[', 'ITSO Delegate', ']')]",
                    "exists": "true"
                    },
                    {
                    "field": "[concat('tags[', 'Service Line', ']')]",
                    "exists": "true"
                    },
                    {
                    "field": "[concat('tags[', 'Service Tier', ']')]",
                    "exists": "true"
                    }
               ]
          }
        }
      }
  }
POLICY_RULE
}

output "policydefinition_audit-rsg-tag" {
  value = azurerm_policy_definition.audit-rsg-tag
}