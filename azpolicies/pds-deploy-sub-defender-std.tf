resource "azurerm_policy_set_definition" "deploy-sub-defender-std" {
  name         = "deploy-sub-defender-std"
  policy_type  = "Custom"
  display_name = "Deploy Azure Defender plan with pricing Tier set to Standard for subscription"
  description  = "Deploy Azure Defender plan with pricing Tier set to Standard for subscription"
  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
    "scd-ctrl-ref": "Azsk",
    "fim-12-ctrl": "LOGM.1,LOGM.2,LOGM.3,ITAM.3,ITOP.2",
    "priority": "P2",
    "source" : "Azsk",
    "exclude-reporting": "true",
    "exclude-from-alerts": "true"
    }

METADATA
  depends_on = [
      azurerm_policy_definition.deploy-sub-defender-str,
      azurerm_policy_definition.deploy-sub-defender-app,
      azurerm_policy_definition.deploy-sub-defender-arm,
      azurerm_policy_definition.deploy-sub-defender-con,
      azurerm_policy_definition.deploy-sub-defender-dns,
      azurerm_policy_definition.deploy-sub-defender-key,
      azurerm_policy_definition.deploy-sub-defender-kub,
      azurerm_policy_definition.deploy-sub-defender-ord,
      azurerm_policy_definition.deploy-sub-defender-sql,
      azurerm_policy_definition.deploy-sub-defender-vms,
      azurerm_policy_definition.deploy-sub-defender-dbs
  ]


  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-sub-defender-str"
    reference_id = "deploysubdefenderstr"
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-sub-defender-app"
    reference_id = "deploysubdefenderapp"
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-sub-defender-arm"
    reference_id = "deploysubdefenderarm"
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-sub-defender-con"
    reference_id = "deploysubdefendercon"
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-sub-defender-dns"
    reference_id = "deploysubdefenderdns"
  }
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-sub-defender-key"
    reference_id = "deploysubdefenderkey"
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-sub-defender-kub"
    reference_id = "deploysubdefenderkub"
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-sub-defender-ord"
    reference_id = "deploysubdefenderord"
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-sub-defender-sql"
    reference_id = "deploysubdefendersql"
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-sub-defender-vms"
    reference_id = "deploysubdefendervms"
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-sub-defender-dbs"
    reference_id = "deploysubdefenderdbs"
  }
}

output "policysetdefinition-deploy-sub-defender-std" {
    value = azurerm_policy_set_definition.deploy-sub-defender-std
}

output "policysetdefinition-deploy-sub-defender-std-definitions" {
    value = [
      azurerm_policy_definition.deploy-sub-defender-str,
      azurerm_policy_definition.deploy-sub-defender-app,
      azurerm_policy_definition.deploy-sub-defender-arm,
      azurerm_policy_definition.deploy-sub-defender-con,
      azurerm_policy_definition.deploy-sub-defender-dns,
      azurerm_policy_definition.deploy-sub-defender-key,
      azurerm_policy_definition.deploy-sub-defender-kub,
      azurerm_policy_definition.deploy-sub-defender-ord,
      azurerm_policy_definition.deploy-sub-defender-sql,
      azurerm_policy_definition.deploy-sub-defender-vms,
      azurerm_policy_definition.deploy-sub-defender-dbs
    ]
}