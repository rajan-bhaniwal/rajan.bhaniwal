resource "azurerm_policy_definition" "audit-acr-vuln-scan" {
  name         = "audit-acr-vuln-scan"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure Container registries must be scanned for security vulnerabilities"
  description  = "Container image vulnerability assessment scans your registry for security vulnerabilities on each pushed container image and exposes detailed findings for each image (powered by Qualys). Resolving the vulnerabilities can greatly improve your containers' security posture and protect them from attacks."
  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "AZR-ACR-CTRL-21",
    "fim-12-ctrl": "VULN.1",
    "priority": "P2",
    "source" : "SCD",
    "exclude-reporting": "true",
    "exclude-from-alerts": "true",
    "version": "2.0.0",
    "category": "Security Center"
    }
METADATA


  policy_rule = <<POLICY_RULE
    {
    "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.ContainerRegistry/registries"
          }
        ]
    },
      "then": {
        "effect": "AuditIfNotExists",
        "details": {
          "type": "Microsoft.Security/assessments",
          "name": "dbd0cb49-b563-45e7-9724-889e799fa648",
          "existenceCondition": {
            "field": "Microsoft.Security/assessments/status.code",
            "in": [
              "NotApplicable",
              "Healthy"
            ]
          }
        }
      }
  }
POLICY_RULE
}

output "policydefinition_audit-acr-vuln-scan" {
  value = azurerm_policy_definition.audit-acr-vuln-scan
}