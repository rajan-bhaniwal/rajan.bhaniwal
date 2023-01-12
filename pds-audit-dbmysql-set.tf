resource "azurerm_policy_set_definition" "audit-dbmysql-set" {
  name         = "audit-dbmysql-set"
  policy_type  = "Custom"
  display_name = "Azure MySQL Server and MySQL flexible servers set"
  description  = "Policy set to audit Azure MySQL Server and MySQL flexible servers "
  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "",
    "fim-l2-ctrl": "",
    "priority": "P2",
    "source" : "SCD",
    "exclude-reporting": "true",
    "exclude-from-alerts": "true"
    }

METADATA
  depends_on = [
  azurerm_policy_definition.audit-dbmysql-tls,
  azurerm_policy_definition.audit-dbmysql-ssl,
  azurerm_policy_definition.audit-dbmysql-pvl,
  azurerm_policy_definition.audit-dbmysql-cmk,  
  azurerm_policy_definition.audit-dbmysql-ad-admin,
  azurerm_policy_definition.audit-dbmysql-flex-ssl,
  azurerm_policy_definition.audit-dbmysql-flex-cmk,
  azurerm_policy_definition.audit-dbmysql-flex-ad-admin
  ]


  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/audit-dbmysql-tls"
    reference_id = "audit-dbmysql-tls"
    parameters     = {
      effect = "[parameters('audit-dbmysql-tls-effect')]"
    }
  }
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/audit-dbmysql-ssl"
    reference_id = "audit-dbmysql-ssl"
    parameters     = {
      effect = "[parameters('audit-dbmysql-ssl-effect')]"
    }
  }
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/audit-dbmysql-pvl"
    reference_id = "audit-dbmysql-pvl"
    parameters     = {
      effect = "[parameters('audit-dbmysql-pvl-effect')]"
    }
  }
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/audit-dbmysql-cmk"
    reference_id = "audit-dbmysql-cmk"
    parameters     = {
      effect = "[parameters('audit-dbmysql-cmk-effect')]"
    }
  }
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/audit-dbmysql-ad-admin"
    reference_id = "audit-dbmysql-ad-admin"
    parameters     = {
      effect = "[parameters('audit-dbmysql-ad-admin-effect')]"
    }
  }
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/audit-dbmysql-flex-ssl"
    reference_id = "audit-dbmysql-flex-ssl"
    parameters     = {
      effect = "[parameters('audit-dbmysql-flex-ssl-effect')]"      
    }
  }
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/audit-dbmysql-flex-cmk"
    reference_id = "audit-dbmysql-flex-cmk"
    parameters     = {
      effect = "[parameters('audit-dbmysql-flex-cmk-effect')]"      
    }
  }
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/audit-dbmysql-flex-ad-admin"
    reference_id = "audit-dbmysql-flex-ad-admin"
    parameters     = {
      effect = "[parameters('audit-dbmysql-flex-ad-admin-effect')]"      
    }
  }

  parameters = <<PARAMETERS
  {
    "audit-dbmysql-tls-effect": {
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
    },
    "audit-dbmysql-ssl-effect": {
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
    },
    "audit-dbmysql-pvl-effect": {
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
    },
    "audit-dbmysql-cmk-effect": {
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
    },
    "audit-dbmysql-ad-admin-effect": {
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
    },
    "audit-dbmysql-flex-ssl-effect": {
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
    },
    "audit-dbmysql-flex-cmk-effect": {
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
    },
    "audit-dbmysql-flex-ad-admin-effect": {
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

output "policysetdefinition-audit-dbmysql-set" {
    value = azurerm_policy_set_definition.audit-dbmysql-set
}

output "policysetdefinition-audit-dbmysql-set-definitions" {
    value = [
      azurerm_policy_definition.audit-dbmysql-tls,
      azurerm_policy_definition.audit-dbmysql-ssl,
      azurerm_policy_definition.audit-dbmysql-pvl,
      azurerm_policy_definition.audit-dbmysql-cmk,  
      azurerm_policy_definition.audit-dbmysql-ad-admin,
      azurerm_policy_definition.audit-dbmysql-flex-ssl,
      azurerm_policy_definition.audit-dbmysql-flex-cmk,
      azurerm_policy_definition.audit-dbmysql-flex-ad-admin
    ]
}