resource "azurerm_policy_definition" "pd-audit-vmss-ssh-lnx" {
  name         = "pd-audit-vmss-ssh-lnx"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Linux Virtual Machines Scaleset must require SSH keys for authentication"
  description  = "Although SSH itself provides an encrypted connection, using passwords with SSH still leaves the VM vulnerable to brute-force attacks. The most secure option for authenticating to an Azure Linux virtual machine over SSH is with a public-private key pair, also known as SSH keys." 

  management_group_name = var.root_management_group_name

  metadata = <<METADATA
    {
      "scd-ctrl-ref": "AZR-VMLP-CTRL-22",
      "fim-12-ctrl": "NSEC.1,NSEC.4,NSEC.5",
      "priority": "P2",
      "source" : "SCD",
      "exclude-reporting": "true",
      "exclude-from-alerts": "true",
      "category": "Guest Configuration",
      "version": "2.0.1",
      "requiredProviders": [
        "Microsoft.GuestConfiguration"
      ],
      "guestConfiguration": {
        "name": "LinuxNoPasswordForSSH",
        "version": "1.*"
      }
    }

METADATA


  policy_rule = <<POLICY_RULE
  {
    "if": {
        "allOf": [
            {
              "field": "type",
              "equals": "Microsoft.Compute/virtualMachineScaleSets"
            },
            {
              "field": "Microsoft.Compute/VirtualMachineScaleSets/osProfile.linuxConfiguration",
              "exists": "true"
            }
        ]
    },
      "then": {
        "effect": "auditIfNotExists",
        "details": {
          "type": "Microsoft.GuestConfiguration/guestConfigurationAssignments",
          "name": "LinuxNoPasswordForSSH",
          "existenceCondition": {
            "field": "Microsoft.GuestConfiguration/guestConfigurationAssignments/complianceStatus",
            "equals": "Compliant"
          }
        }
      }
  }
POLICY_RULE
}

output "policydefinition_pd-audit-vmss-ssh-lnx" {
  value = azurerm_policy_definition.pd-audit-vmss-ssh-lnx
}