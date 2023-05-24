output "policy_definition_reference_ids" {
    value = azurerm_policy_set_definition.example.policy_definition_reference.*.reference_id
}