resource "azurerm_policy_assignment" "deploy-sub-defender-std-hsbc" {
  name                 = "deploy-defender-std"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.root_management_group_name}"
  policy_definition_id = azurerm_policy_set_definition.deploy-sub-defender-std.id
  description          = "Deploy Azure Defender plan with pricing Tier set to Standard for subscription"
  display_name         = "Deploy Azure Defender plan with pricing Tier set to Standard for subscription"
  location             = "westeurope"

identity {
    type = "SystemAssigned"
}
  
  parameters = <<PARAMETERS
{
 
}
PARAMETERS


}