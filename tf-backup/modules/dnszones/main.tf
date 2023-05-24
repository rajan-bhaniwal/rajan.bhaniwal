
resource "azurerm_policy_set_definition" "example" {
  name         = var.policy_name
  policy_type  = var.policy_type
  display_name = var.policy_display_name
  description  = var.policy_display_description
  management_group_name = var.policy_management_group_name

  parameters = var.parameters

  dynamic "policy_definition_reference" {
    for_each = toset(var.dnsZones)

    content {
        policy_definition_id = policy_definition_reference.key.policy_definition_id
        parameters = policy_definition_reference.key.parameters
        reference_id = policy_definition_reference.key.reference_id
    }
  }
}