variable "policy_name" {
    type = string
}

variable "policy_type" {
    type = string
}

variable "policy_display_name" {
    type = string
}

variable "policy_display_description" {
    type = string
}

variable "policy_management_group_name" {
    type = string
}

variable "parameters" {
    type = string
}

variable "dnsZones" {
  type = list(object({
    policy_definition_id = string
    reference_id = string
    parameters = map(string)
  }))
}