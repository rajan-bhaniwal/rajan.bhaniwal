resource "azurerm_policy_set_definition" "deploy-vm-azure-monitor-extn" {
  name         = "deploy-vm-azure-monitor-extn"
  policy_type  = "Custom"
  display_name = "Enable Azure Monitor and vmInsight for VMs and Scalesets"
  description  = "Enable Azure Monitor and vmInsight for the virtual machines and scalesets"
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
  azurerm_policy_definition.deploy-oms-vminsights,
  azurerm_policy_definition.deploy-vm-dep-lnx-extn,
  azurerm_policy_definition.deploy-vm-dep-win-extn,
  azurerm_policy_definition.deploy-vm-mon-lnx-extn,  
  azurerm_policy_definition.deploy-vm-mon-win-extn,
  azurerm_policy_definition.deploy-vmss-dep-lnx-extn,
  azurerm_policy_definition.deploy-vmss-dep-win-extn,
  azurerm_policy_definition.deploy-vmss-mon-lnx-extn,  
  azurerm_policy_definition.deploy-vmss-mon-win-extn
  ]


  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-oms-vminsights"
    reference_id = "deployomsvminsights"
    parameters     = {
      effect = "[parameters('deploy-oms-vminsights-effect')]"
    }
  }
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-vm-dep-lnx-extn"
    reference_id = "deployvmdeplnxextn"
    parameters     = {
      effect = "[parameters('deploy-vm-dep-lnx-extn-effect')]"
    }
  }
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-vm-dep-win-extn"
    reference_id = "deployvmdepwinextn"
    parameters     = {
      effect = "[parameters('deploy-vm-dep-win-extn-effect')]"
    }
  }
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-vm-mon-lnx-extn"
    reference_id = "deployvmmonlnxextn"
    parameters     = {
      effect = "[parameters('deploy-vm-mon-lnx-extn-effect')]"
    }
  }
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-vm-mon-win-extn"
    reference_id = "deployvmmonwinextn"
    parameters     = {
      effect = "[parameters('deploy-vm-mon-win-extn-effect')]"
    }
  }
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-vmss-dep-lnx-extn"
    reference_id = "deployvmssdeplnxextn"
    parameters     = {
      effect = "[parameters('deploy-vmss-dep-lnx-extn-effect')]"      
    }
  }
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-vmss-dep-win-extn"
    reference_id = "deployvmssdepwinextn"
    parameters     = {
      effect = "[parameters('deploy-vmss-dep-win-extn-effect')]"      
    }
  }
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-vmss-mon-lnx-extn"
    reference_id = "deployvmssmonlnxextn"
    parameters     = {
      effect = "[parameters('deploy-vmss-mon-lnx-extn-effect')]"      
    }
  }
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}/providers/Microsoft.Authorization/policyDefinitions/deploy-vmss-mon-win-extn"
    reference_id = "deployvmssmonwinextn"
    parameters     = {
      effect = "[parameters('deploy-vmss-mon-win-extn-effect')]"      
    }
  }

  parameters = <<PARAMETERS
  {
    "deploy-oms-vminsights-effect": {
      "type": "String",
      "metadata": {
        "displayName": "Effect",
        "description": "Enable or disable the execution of the policy"
      },
      "allowedValues": [
        "DeployIfNotExists",
        "Disabled"
      ],
      "defaultValue": "DeployIfNotExists"
    },
    "deploy-vm-dep-lnx-extn-effect": {
      "type": "String",
      "metadata": {
        "displayName": "Effect",
        "description": "Enable or disable the execution of the policy"
      },
      "allowedValues": [
        "DeployIfNotExists",
        "Disabled"
      ],
      "defaultValue": "DeployIfNotExists"
    },
    "deploy-vm-dep-win-extn-effect": {
      "type": "String",
      "metadata": {
        "displayName": "Effect",
        "description": "Enable or disable the execution of the policy"
      },
      "allowedValues": [
        "DeployIfNotExists",
        "Disabled"
      ],
      "defaultValue": "DeployIfNotExists"
    },
    "deploy-vm-mon-lnx-extn-effect": {
      "type": "String",
      "metadata": {
        "displayName": "Effect",
        "description": "Enable or disable the execution of the policy"
      },
      "allowedValues": [
        "DeployIfNotExists",
        "Disabled"
      ],
      "defaultValue": "DeployIfNotExists"
    },
    "deploy-vm-mon-win-extn-effect": {
      "type": "String",
      "metadata": {
        "displayName": "Effect",
        "description": "Enable or disable the execution of the policy"
      },
      "allowedValues": [
        "DeployIfNotExists",
        "Disabled"
      ],
      "defaultValue": "DeployIfNotExists"
    },
    "deploy-vmss-dep-lnx-extn-effect": {
      "type": "String",
      "metadata": {
        "displayName": "Effect",
        "description": "Enable or disable the execution of the policy"
      },
      "allowedValues": [
        "DeployIfNotExists",
        "Disabled"
      ],
      "defaultValue": "DeployIfNotExists"
    },
    "deploy-vmss-dep-win-extn-effect": {
      "type": "String",
      "metadata": {
        "displayName": "Effect",
        "description": "Enable or disable the execution of the policy"
      },
      "allowedValues": [
        "DeployIfNotExists",
        "Disabled"
      ],
      "defaultValue": "DeployIfNotExists"
    },
    "deploy-vmss-mon-lnx-extn-effect": {
      "type": "String",
      "metadata": {
        "displayName": "Effect",
        "description": "Enable or disable the execution of the policy"
      },
      "allowedValues": [
        "DeployIfNotExists",
        "Disabled"
      ],
      "defaultValue": "DeployIfNotExists"
    },
    "deploy-vmss-mon-win-extn-effect": {
      "type": "String",
      "metadata": {
        "displayName": "Effect",
        "description": "Enable or disable the execution of the policy"
      },
      "allowedValues": [
        "DeployIfNotExists",
        "Disabled"
      ],
      "defaultValue": "DeployIfNotExists"
    }         
  }
PARAMETERS

}

output "policysetdefinition-deploy-vm-azure-monitor-extn" {
    value = azurerm_policy_set_definition.deploy-vm-azure-monitor-extn
}

output "policysetdefinition-deploy-vm-azure-monitor-extn-definitions" {
    value = [
      azurerm_policy_definition.deploy-oms-vminsights,
      azurerm_policy_definition.deploy-vm-dep-lnx-extn,
      azurerm_policy_definition.deploy-vm-dep-win-extn,
      azurerm_policy_definition.deploy-vm-mon-lnx-extn,  
      azurerm_policy_definition.deploy-vm-mon-win-extn,
      azurerm_policy_definition.deploy-vmss-dep-lnx-extn,
      azurerm_policy_definition.deploy-vmss-dep-win-extn,
      azurerm_policy_definition.deploy-vmss-mon-lnx-extn,  
      azurerm_policy_definition.deploy-vmss-mon-win-extn
    ]
}