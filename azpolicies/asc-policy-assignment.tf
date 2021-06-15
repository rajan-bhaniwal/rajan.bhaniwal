data "azurerm_policy_set_definition" "asc-default" {
  display_name = "Azure Security Benchmark"
}

data "azurerm_management_group" "mg" {
  name = "root_management_garoup"
}

resource "azurerm_policy_assignment" "asc-default" {
  name                 = "asc-policy-assignment"
  scope                = data.azurerm_management_group.mg.id
  policy_definition_id = data.azurerm_policy_set_definition.asc-default.id
  description          = "ASC Default"
  display_name         = "ASC Default"
  location             = "westeurope"

identity {
    type = "SystemAssigned"
}
  
  parameters = <<PARAMETERS
{

      "useServicePrincipalToProtectSubscriptionsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Service principals should be used to protect your subscriptions instead of management certificates",
          "description": "Management certificates allow anyone who authenticates with them to manage the subscription(s) they are associated with. To manage subscriptions more securely, use of service principals with Resource Manager is recommended to limit the impact of a certificate compromise."
        }
      },
      "allowedContainerImagesInKubernetesClusterEffect": {
        "type": "string",
        "Value": "disabled",
        "allowedValues": [
          "audit",
          "deny",
          "disabled"
        ],
        "metadata": {
          "displayName": "Container images should be deployed from trusted registries only",
          "description": "Enable or disable monitoring of allowed container images in Kubernetes clusters"
        }
      },
      "vmssSystemUpdatesMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "System updates on virtual machine scale sets should be installed",
          "description": "Enable or disable virtual machine scale sets reporting of system updates"
        }
      },
      "jitNetworkAccessMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Management ports of virtual machines should be protected with just-in-time network access control",
          "description": "Enable or disable the monitoring of network just-in-time access"
        }
      },
      "adaptiveApplicationControlsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Adaptive application controls for defining safe applications should be enabled on your machines",
          "description": "Enable or disable application controls to define the list of known-safe applications running on your machines, and alert you when other applications run"
        }
      },
      "containerBenchmarkMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Vulnerabilities in container security configurations should be remediated",
          "description": "Enable or disable container benchmark monitoring"
        }
      },
      "azureBackupShouldBeEnabledForVirtualMachinesMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Backup should be enabled for Virtual Machines",
          "description": "Ensure protection of your Azure Virtual Machines by enabling Azure Backup. Azure Backup is a secure and cost effective data protection solution for Azure."
        }
      },
      "subscriptionsShouldHaveAContactEmailAddressForSecurityIssuesMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Subscriptions should have a contact email address for security issues",
          "description": "To ensure the relevant people in your organization are notified when there is a potential security breach in one of your subscriptions, set a security contact to receive email notifications from Security Center."
        }
      },
      "autoProvisioningOfTheLogAnalyticsAgentShouldBeEnabledOnYourSubscriptionMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Auto provisioning of the Log Analytics agent should be enabled on your subscription",
          "description": "To monitor for security vulnerabilities and threats, Azure Security Center collects data from your Azure virtual machines. Data is collected by the Log Analytics agent, formerly known as the Microsoft Monitoring Agent (MMA), which reads various security-related configurations and event logs from the machine and copies the data to your Log Analytics workspace for analysis. We recommend enabling auto provisioning to automatically deploy the agent to all supported Azure VMs and any new ones that are created."
        }
      },
      "systemUpdatesMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "System updates should be installed on your machines",
          "description": "Enable or disable reporting of system updates"
        }
      },
      "cognitiveServicesAccountsShouldRestrictNetworkAccessMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Cognitive Services accounts should restrict network access",
          "description": "Network access to Cognitive Services accounts should be restricted. Configure network rules so only applications from allowed networks can access the Cognitive Services account. To allow connections from specific internet or on-premises clients, access can be granted to traffic from specific Azure virtual networks or to public internet IP address ranges."
        }
      },
      "publicNetworkAccessShouldBeDisabledForPostgreSqlServersMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Public network access should be disabled for PostgreSQL servers",
          "description": "Disable the public network access property to improve security and ensure your Azure Database for PostgreSQL can only be accessed from a private endpoint. This configuration disables access from any public address space outside of Azure IP range, and denies all logins that match IP or virtual network-based firewall rules."
        }
      },
      "ensureThatPythonVersionIsTheLatestIfUsedAsAPartOfTheWebAppMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Ensure that Python version is the latest if used as a part of the Web app",
          "description": "Periodically, newer versions are released for Python software either due to security flaws or to include additional functionality. Using the latest Python version for web apps is recommended in order to take advantage of security fixes, if any, and/or new functionalities of the latest version. Currently, this policy only applies to Linux web apps."
        }
      },
      "georedundantBackupShouldBeEnabledForAzureDatabaseForPostgresqlMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Georedundant backup should be enabled for Azure Database for PostgreSQL",
          "description": "Azure Database for PostgreSQL allows you to choose the redundancy option for your database server. It can be set to a geo-redundant backup storage in which the data is not only stored within the region in which your server is hosted, but is also replicated to a paired region to provide recovery option in case of a region failure. Configuring geo-redundant storage for backup is only allowed during server create."
        }
      },
      "adaptiveApplicationControlsUpdateMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Allowlist rules in your adaptive application control policy should be updated",
          "description": "Enable or disable the monitoring for changes in behavior on groups of machines configured for auditing by Azure Security Center's adaptive application controls"
        }
      },
      "emailNotificationForHighSeverityAlertsShouldBeEnabledMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Email notification for high severity alerts should be enabled",
          "description": "To ensure the relevant people in your organization are notified when there is a potential security breach in one of your subscriptions, enable email notifications for high severity alerts in Security Center."
        }
      },
      "emailNotificationToSubscriptionOwnerForHighSeverityAlertsShouldBeEnabledMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Email notification to subscription owner for high severity alerts should be enabled",
          "description": "To ensure your subscription owners are notified when there is a potential security breach in their subscription, set email notifications to subscription owners for high severity alerts in Security Center."
        }
      },
      "resolveLogAnalyticsHealthIssuesMonitoringEffect": {
        "type": "string",
        "Value": "AuditIfNotExists",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Log Analytics agent health issues should be resolved on your machines",
          "description": "Security Center uses the Log Analytics agent, formerly known as the Microsoft Monitoring Agent (MMA). To make sure your virtual machines are successfully monitored, you need to make sure the agent is installed on the virtual machines and properly collects security events to the configured workspace."
        }
      },
      "installLogAnalyticsAgentOnVmMonitoringEffect": {
        "type": "string",
        "Value": "AuditIfNotExists",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Log Analytics agent should be installed on your virtual machine for Azure Security Center monitoring",
          "description": "This policy audits any Windows/Linux virtual machines (VMs) if the Log Analytics agent is not installed which Security Center uses to monitor for security vulnerabilities and threats"
        }
      },
      "installLogAnalyticsAgentOnVmssMonitoringEffect": {
        "type": "string",
        "Value": "AuditIfNotExists",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Log Analytics agent should be installed on your virtual machine scale sets for Azure Security Center monitoring",
          "description": "Security Center collects data from your Azure virtual machines (VMs) to monitor for security vulnerabilities and threats."
        }
      },
      "secretsExpirationSetEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Key Vault secrets should have expiration dates set",
          "description": "Enable or disable key vault secrets should have expiration dates set."
        }
      },
      "keysExpirationSetEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Key Vault keys should have expiration dates set",
          "description": "Enable or disable key vault keys should have expiration dates set."
        }
      },
      "azurePolicyforWindowsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Guest Configuration extension should be installed on virtual machines",
          "description": "Enable or disable virtual machines reporting that the Guest Configuration extension should be installed"
        }
      },
      "gcExtOnVMWithNoSAMIMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Virtual machines' Guest Configuration extension should be deployed with system-assigned managed identity",
          "description": "Enable or disable Virtual machines' Guest Configuration extension should be deployed with system-assigned managed identity"
        }
      },
      "windowsDefenderExploitGuardMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Windows Defender Exploit Guard should be enabled on your Windows virtual machines",
          "description": "Enable or disable virtual machines reporting that Windows Defender Exploit Guard is enabled"
        }
      },
      "windowsGuestConfigBaselinesMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Vulnerabilities in security configuration on your Windows machines should be remediated (powered by Guest Config)",
          "description": "Enable or disable virtual machines reporting Windows Baselines in Guest Config"
        }
      },
      "linuxGuestConfigBaselinesMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Vulnerabilities in security configuration on your Linux machines should be remediated (powered by Guest Config)",
          "description": "Enable or disable virtual machines reporting Linux Baselines in Guest Config"
        }
      },
      "vmssEndpointProtectionMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Endpoint protection solution should be installed on virtual machine scale sets",
          "description": "Enable or disable virtual machine scale sets endpoint protection monitoring"
        }
      },
      "vmssOsVulnerabilitiesMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Vulnerabilities in security configuration on your virtual machine scale sets should be remediated",
          "description": "Enable or disable virtual machine scale sets OS vulnerabilities monitoring"
        }
      },
      "systemConfigurationsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Vulnerabilities in security configuration on your machines should be remediated",
          "description": "Enable or disable OS vulnerabilities monitoring (based on a configured baseline)"
        }
      },
      "diskEncryptionMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Disk encryption should be applied on virtual machines",
          "description": "Enable or disable the monitoring for VM disk encryption"
        }
      },
      "networkSecurityGroupsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor network security groups",
          "description": "Enable or disable monitoring of network security groups with permissive rules",
          "deprecated": true
        }
      },
      "networkSecurityGroupsOnSubnetsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Network Security Groups on the subnet level should be enabled",
          "description": "Enable or disable monitoring of NSGs on subnets"
        }
      },
      "networkSecurityGroupsOnVirtualMachinesMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Internet-facing virtual machines should be protected with network security groups",
          "description": "Enable or disable monitoring of NSGs on VMs"
        }
      },
      "networkSecurityGroupsOnInternalVirtualMachinesMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Non-internet-facing virtual machines should be protected with network security groups",
          "description": "Enable or disable monitoring of NSGs on VMs"
        }
      },
      "webApplicationFirewallMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Web ports should be restricted on Network Security Groups associated to your VM",
          "description": "Enable or disable the monitoring of unprotected web applications",
          "deprecated": true
        }
      },
      "nextGenerationFirewallMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "All network ports should be restricted on network security groups associated to your virtual machine",
          "description": "Enable or disable overly permissive inbound NSG rules monitoring."
        }
      },
      "vulnerabilityAssesmentMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Vulnerabilities should be remediated by a Vulnerability Assessment solution",
          "description": "Enable or disable the detection of VM vulnerabilities by a vulnerability assessment solution",
          "deprecated": true
        }
      },
      "serverVulnerabilityAssessmentEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "A vulnerability assessment solution should be enabled on your virtual machines",
          "description": "Enable or disable the detection of virtual machine vulnerabilities by Azure Security Center vulnerability assessment"
        }
      },
      "storageEncryptionMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Audit missing blob encryption for storage accounts",
          "description": "Enable or disable the monitoring of blob encryption for storage accounts",
          "deprecated": true
        }
      },
      "sqlAuditingMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor unaudited SQL servers in Azure Security Center",
          "description": "Enable or disable the monitoring of unaudited SQL databases",
          "deprecated": true
        }
      },
      "sqlEncryptionMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor unencrypted SQL databases in Azure Security Center",
          "description": "Enable or disable the monitoring of unencrypted SQL databases",
          "deprecated": true
        }
      },
      "sqlDbEncryptionMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Transparent Data Encryption on SQL databases should be enabled",
          "description": "Enable or disable the monitoring of unencrypted SQL databases"
        }
      },
      "sqlServerAuditingMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Auditing should be enabled on advanced data security settings on SQL Server",
          "description": "Enable or disable the monitoring of unaudited SQL Servers"
        }
      },
      "sqlServerAuditingActionsAndGroupsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "SQL Auditing settings should have Action-Groups configured to capture critical activities",
          "description": "Enable or disable the monitoring of auditing policy Action-Groups and Actions setting",
          "deprecated": true
        }
      },
      "diagnosticsLogsInAppServiceMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor resource logs in Azure App Services",
          "description": "Enable or disable the monitoring of resource logs in Azure App Services",
          "deprecated": true
        }
      },
      "diagnosticsLogsInSelectiveAppServicesMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Resource logs in App Services should be enabled",
          "description": "Enable or disable the monitoring of resource logs in Azure App Services",
          "deprecated": true
        }
      },
      "encryptionOfAutomationAccountMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Automation account variables should be encrypted",
          "description": "Enable or disable the monitoring of automation account encryption"
        }
      },
      "diagnosticsLogsInDataLakeAnalyticsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Resource logs in Data Lake Analytics should be enabled",
          "description": "Enable or disable the monitoring of resource logs in Data Lake Analytics accounts"
        }
      },
      "diagnosticsLogsInDataLakeStoreMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Resource logs in Azure Data Lake Store should be enabled",
          "description": "Enable or disable the monitoring of resource logs in Data Lake Store accounts"
        }
      },
      "diagnosticsLogsInEventHubMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Resource logs in Event Hub should be enabled",
          "description": "Enable or disable the monitoring of resource logs in Event Hub accounts"
        }
      },
      "diagnosticsLogsInKeyVaultMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Resource logs in Key Vault should be enabled",
          "description": "Enable or disable the monitoring of resource logs in Key Vault vaults"
        }
      },
      "diagnosticsLogsInLogicAppsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Resource logs in Logic Apps should be enabled",
          "description": "Enable or disable the monitoring of resource logs in Logic Apps workflows"
        }
      },
      "diagnosticsLogsInRedisCacheMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Only secure connections to your Redis Cache should be enabled",
          "description": "Enable or disable the monitoring of resource logs in Azure Redis Cache"
        }
      },
      "diagnosticsLogsInSearchServiceMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Resource logs in Search services should be enabled",
          "description": "Enable or disable the monitoring of resource logs in Azure Search service"
        }
      },
      "diagnosticsLogsInServiceBusMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Resource logs in Service Bus should be enabled",
          "description": "Enable or disable the monitoring of resource logs in Service Bus"
        }
      },
      "diagnosticsLogsInServiceBusRetentionDays": {
        "type": "string",
        "Value": "1",
        "metadata": {
          "displayName": "Required retention (in days) of logs in Service Bus",
          "description": "The required resource logs retention period in days"
        }
      },
      "namespaceAuthorizationRulesInServiceBusMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "All authorization rules except RootManageSharedAccessKey should be removed from Service Bus namespace",
          "description": "Enable or disable the monitoring of Service Bus namespace authorization rules",
          "deprecated": true
        }
      },
      "aadAuthenticationInSqlServerMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "An Azure Active Directory administrator should be provisioned for SQL servers",
          "description": "Enable or disable the monitoring of an Azure AD admininistrator for SQL server"
        }
      },
      "secureTransferToStorageAccountMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Secure transfer to storage accounts should be enabled",
          "description": "Enable or disable the monitoring of secure transfer to storage account"
        }
      },
      "diagnosticsLogsInStreamAnalyticsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Resource logs in Azure Stream Analytics should be enabled",
          "description": "Enable or disable the monitoring of resource logs in Stream Analytics"
        }
      },
      "diagnosticsLogsInStreamAnalyticsRetentionDays": {
        "type": "string",
        "Value": "1",
        "metadata": {
          "displayName": "Required retention (in days) of logs in Stream Analytics",
          "description": "The required resource logs retention period in days"
        }
      },
      "useRbacRulesMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Audit usage of custom RBAC rules",
          "description": "Enable or disable the monitoring of using built-in RBAC rules"
        }
      },
      "disableUnrestrictedNetworkToStorageAccountMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Audit unrestricted network access to storage accounts",
          "description": "Enable or disable the monitoring of network access to storage account"
        }
      },
      "diagnosticsLogsInServiceFabricMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Resource logs in Virtual Machine Scale Sets should be enabled",
          "description": "Enable or disable the monitoring of resource logs in Service Fabric"
        }
      },
      "accessRulesInEventHubNamespaceMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "All authorization rules except RootManageSharedAccessKey should be removed from Event Hub namespace",
          "description": "Enable or disable the monitoring of access rules in Event Hub namespaces",
          "deprecated": true
        }
      },
      "accessRulesInEventHubMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Authorization rules on the Event Hub instance should be defined",
          "description": "Enable or disable the monitoring of access rules in Event Hubs",
          "deprecated": true
        }
      },
      "sqlDbVulnerabilityAssesmentMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "SQL databases should have vulnerability findings resolved",
          "description": "Enable or disable the monitoring of vulnerability assessment scan results and recommendations for how to remediate database vulnerabilities."
        }
      },
      "serverSqlDbVulnerabilityAssesmentMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "SQL servers on machines should have vulnerability findings resolved",
          "description": "SQL Vulnerability assessment scans your database for security vulnerabilities, and exposes any deviations from best practices such as misconfigurations, excessive permissions, and unprotected sensitive data. Resolving the vulnerabilities found can greatly improve your database security posture."
        }
      },
      "sqlDbDataClassificationMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Sensitive data in your SQL databases should be classified",
          "description": "Enable or disable the monitoring of sensitive data classification in databases."
        }
      },
      "identityDesignateLessThanOwnersMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "A maximum of 3 owners should be designated for your subscription",
          "description": "Enable or disable the monitoring of maximum owners in subscription"
        }
      },
      "identityDesignateMoreThanOneOwnerMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "There should be more than one owner assigned to your subscription",
          "description": "Enable or disable the monitoring of minimum owners in subscription"
        }
      },
      "identityEnableMFAForOwnerPermissionsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "MFA should be enabled on accounts with owner permissions on your subscription",
          "description": "Enable or disable the monitoring of MFA for accounts with owner permissions in subscription"
        }
      },
      "identityEnableMFAForWritePermissionsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "MFA should be enabled accounts with write permissions on your subscription",
          "description": "Enable or disable the monitoring of MFA for accounts with write permissions in subscription"
        }
      },
      "identityEnableMFAForReadPermissionsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "MFA should be enabled on accounts with read permissions on your subscription",
          "description": "Enable or disable the monitoring of MFA for accounts with read permissions in subscription"
        }
      },
      "identityRemoveDeprecatedAccountWithOwnerPermissionsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Deprecated accounts with owner permissions should be removed from your subscription",
          "description": "Enable or disable the monitoring of deprecated acounts with owner permissions in subscription"
        }
      },
      "identityRemoveDeprecatedAccountMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Deprecated accounts should be removed from your subscription",
          "description": "Enable or disable the monitoring of deprecated acounts in subscription"
        }
      },
      "identityRemoveExternalAccountWithOwnerPermissionsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "External accounts with owner permissions should be removed from your subscription",
          "description": "Enable or disable the monitoring of external acounts with owner permissions in subscription"
        }
      },
      "identityRemoveExternalAccountWithWritePermissionsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "External accounts with write permissions should be removed from your subscription",
          "description": "Enable or disable the monitoring of external acounts with write permissions in subscription"
        }
      },
      "identityRemoveExternalAccountWithReadPermissionsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "External accounts with read permissions should be removed from your subscription",
          "description": "Enable or disable the monitoring of external acounts with read permissions in subscription"
        }
      },
      "apiAppConfigureIPRestrictionsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor Configure IP restrictions for API App",
          "description": "Enable or disable the monitoring of IP restrictions for API App",
          "deprecated": true
        }
      },
      "functionAppConfigureIPRestrictionsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor Configure IP restrictions for Function App",
          "description": "Enable or disable the monitoring of IP restrictions for Function App",
          "deprecated": true
        }
      },
      "webAppConfigureIPRestrictionsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor Configure IP restrictions for Web App",
          "description": "Enable or disable the monitoring of IP restrictions for Web App",
          "deprecated": true
        }
      },
      "apiAppDisableRemoteDebuggingMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Remote debugging should be turned off for API App",
          "description": "Enable or disable the monitoring of remote debugging for API App"
        }
      },
      "functionAppDisableRemoteDebuggingMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Remote debugging should be turned off for Function App",
          "description": "Enable or disable the monitoring of remote debugging for Function App"
        }
      },
      "webAppDisableRemoteDebuggingMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Remote debugging should be turned off for Web Application",
          "description": "Enable or disable the monitoring of remote debugging for Web App"
        }
      },
      "apiAppAuditFtpsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "FTPS should be required in your API App",
          "description": "Enable FTPS enforcement for enhanced security",
          "deprecated": true
        }
      },
      "functionAppAuditFtpsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "FTPS should be required in your Function App",
          "description": "Enable FTPS enforcement for enhanced security",
          "deprecated": true
        }
      },
      "webAppAuditFtpsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "FTPS should be required in your Web App",
          "description": "Enable FTPS enforcement for enhanced security",
          "deprecated": true
        }
      },
      "apiAppUseManagedIdentityMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "A managed identity should be used in your API App",
          "description": "Use a managed identity for enhanced authentication security",
          "deprecated": true
        }
      },
      "functionAppUseManagedIdentityMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "A managed identity should be used in your Function App",
          "description": "Use a managed identity for enhanced authentication security",
          "deprecated": true
        }
      },
      "webAppUseManagedIdentityMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "A managed identity should be used in your Web App",
          "description": "Use a managed identity for enhanced authentication security",
          "deprecated": true
        }
      },
      "apiAppRequireLatestTlsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Latest TLS version should be used in your API App",
          "description": "Upgrade to the latest TLS version",
          "deprecated": true
        }
      },
      "functionAppRequireLatestTlsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Latest TLS version should be used in your Function App",
          "description": "Upgrade to the latest TLS version",
          "deprecated": true
        }
      },
      "webAppRequireLatestTlsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Latest TLS version should be used in your Web App",
          "description": "Upgrade to the latest TLS version",
          "deprecated": true
        }
      },
      "apiAppDisableWebSocketsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor disable web sockets for API App",
          "description": "Enable or disable the monitoring of web sockets for API App",
          "deprecated": true
        }
      },
      "functionAppDisableWebSocketsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor disable web sockets for Function App",
          "description": "Enable or disable the monitoring of web sockets for Function App",
          "deprecated": true
        }
      },
      "webAppDisableWebSocketsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor disable web sockets for Web App",
          "description": "Enable or disable the monitoring of web sockets for Web App",
          "deprecated": true
        }
      },
      "apiAppEnforceHttpsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "API App should only be accessible over HTTPS",
          "description": "Enable or disable the monitoring of the use of HTTPS in API App",
          "deprecated": true
        }
      },
      "functionAppEnforceHttpsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Function App should only be accessible over HTTPS",
          "description": "Enable or disable the monitoring of the use of HTTPS in function App",
          "deprecated": true
        }
      },
      "webAppEnforceHttpsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Web Application should only be accessible over HTTPS",
          "description": "Enable or disable the monitoring of the use of HTTPS in Web App",
          "deprecated": true
        }
      },
      "apiAppEnforceHttpsMonitoringEffectV2": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "API App should only be accessible over HTTPS V2",
          "description": "Enable or disable the monitoring of the use of HTTPS in API App V2"
        }
      },
      "functionAppEnforceHttpsMonitoringEffectV2": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Function App should only be accessible over HTTPS V2",
          "description": "Enable or disable the monitoring of the use of HTTPS in function App V2"
        }
      },
      "webAppEnforceHttpsMonitoringEffectV2": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Web Application should only be accessible over HTTPS V2",
          "description": "Enable or disable the monitoring of the use of HTTPS in Web App V2"
        }
      },
      "apiAppRestrictCORSAccessMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "CORS should not allow every resource to access your API App",
          "description": "Enable or disable the monitoring of CORS restrictions for API App"
        }
      },
      "functionAppRestrictCORSAccessMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "CORS should not allow every resource to access your Function App",
          "description": "Enable or disable the monitoring of CORS restrictions for API Function"
        }
      },
      "webAppRestrictCORSAccessMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "CORS should not allow every resource to access your Web Application",
          "description": "Enable or disable the monitoring of CORS restrictions for API Web"
        }
      },
      "apiAppUsedCustomDomainsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor the custom domain use in API App",
          "description": "Enable or disable the monitoring of custom domain use in API App",
          "deprecated": true
        }
      },
      "functionAppUsedCustomDomainsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor the custom domain use in Function App",
          "description": "Enable or disable the monitoring of custom domain use in Function App",
          "deprecated": true
        }
      },
      "webAppUsedCustomDomainsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor the custom domain use in Web App",
          "description": "Enable or disable the monitoring of custom domain use in Web App",
          "deprecated": true
        }
      },
      "apiAppUsedLatestDotNetMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor use latest .NET in API App",
          "description": "Enable or disable the monitoring of .NET version in API App",
          "deprecated": true
        }
      },
      "webAppUsedLatestDotNetMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor use latest .NET in Web App",
          "description": "Enable or disable the monitoring of .NET version in Web App",
          "deprecated": true
        }
      },
      "apiAppUsedLatestJavaMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor use latest Java in API App",
          "description": "Enable or disable the monitoring of Java version in API App",
          "deprecated": true
        }
      },
      "webAppUsedLatestJavaMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor use latest Java in Web App",
          "description": "Enable or disable the monitoring of Java version in Web App",
          "deprecated": true
        }
      },
      "webAppUsedLatestNodeJsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor use latest Node.js in Web App",
          "description": "Enable or disable the monitoring of Node.js version in Web App",
          "deprecated": true
        }
      },
      "apiAppUsedLatestPHPMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor use latest PHP in API App",
          "description": "Enable or disable the monitoring of PHP version in API App",
          "deprecated": true
        }
      },
      "webAppUsedLatestPHPMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor use latest PHP in Web App",
          "description": "Enable or disable the monitoring of PHP version in Web App",
          "deprecated": true
        }
      },
      "apiAppUsedLatestPythonMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor use latest Python in API App",
          "description": "Enable or disable the monitoring of Python version in API App",
          "deprecated": true
        }
      },
      "webAppUsedLatestPythonMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Monitor use latest Python in Web App",
          "description": "Enable or disable the monitoring of Python version in Web App",
          "deprecated": true
        }
      },
      "vnetEnableDDoSProtectionMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure DDoS Protection Standard should be enabled",
          "description": "Enable or disable the monitoring of DDoS protection for virtual network"
        }
      },
      "diagnosticsLogsInIoTHubMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Resource logs in IoT Hub should be enabled",
          "description": "Enable or disable the monitoring of resource logs in IoT Hubs"
        }
      },
      "diagnosticsLogsInIoTHubRetentionDays": {
        "type": "string",
        "Value": "1",
        "metadata": {
          "displayName": "Required retention (in days) of logs in IoT Hub accounts",
          "description": "The required resource logs retention period in days"
        }
      },
      "sqlServerAdvancedDataSecurityMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Advanced data security should be enabled on your SQL servers",
          "description": "Enable or disable the monitoring of SQL servers without Advanced Data Security"
        }
      },
      "sqlManagedInstanceAdvancedDataSecurityMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Advanced data security should be enabled on SQL Managed Instance",
          "description": "Enable or disable the monitoring of each SQL Managed Instance without advanced data security."
        }
      },
      "sqlServerAdvancedDataSecurityEmailsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Advanced data security settings for SQL server should contain an email address to receive security alerts",
          "description": "Enable or disable the monitoring that advanced data security settings for SQL server contain at least one email address to receive security alerts",
          "deprecated": true
        }
      },
      "sqlManagedInstanceAdvancedDataSecurityEmailsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Advanced data security settings for SQL Managed Instance should contain an email address to receive security alerts",
          "description": "Enable or disable the monitoring that advanced data security settings for SQL Managed Instance contain at least one email address to receive security alerts.",
          "deprecated": true
        }
      },
      "sqlServerAdvancedDataSecurityEmailAdminsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Email notifications to admins and subscription owners should be enabled in SQL server advanced data security settings",
          "description": "Enable or disable auditing that 'email notification to admins and subscription owners' is enabled in the SQL Server advanced threat protection settings. This ensures that any detections of anomalous activities on SQL server are reported as soon as possible to the admins.",
          "deprecated": true
        }
      },
      "sqlManagedInstanceAdvancedDataSecurityEmailAdminsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Email notifications to admins and subscription owners should be enabled in SQL Managed Instance advanced data security settings",
          "description": "Enable or disable auditing that 'email notification to admins and subscription owners' is enabled in SQL Managed Instance advanced threat protection settings. This setting ensures that any detections of anomalous activities on SQL Managed Instance are reported as soon as possible to the admins.",
          "deprecated": true
        }
      },
      "kubernetesServiceRbacEnabledMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Role-Based Access Control (RBAC) should be used on Kubernetes Services",
          "description": "Enable or disable the monitoring of Kubernetes Services without RBAC enabled"
        }
      },
      "kubernetesServicePspEnabledMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Pod Security Policies should be defined on Kubernetes Services",
          "description": "Enable or disable the monitoring of Kubernetes Services without Pod Security Policy enabled",
          "deprecated": true
        }
      },
      "kubernetesServiceAuthorizedIPRangesEnabledMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Authorized IP ranges should be defined on Kubernetes Services",
          "description": "Enable or disable the monitoring of Kubernetes Services without Authorized IP Ranges enabled"
        }
      },
      "kubernetesServiceVersionUpToDateMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Kubernetes Services should be upgraded to a non vulnerable Kubernetes version",
          "description": "Enable or disable the monitoring of the Kubernetes Services with versions that contain known vulnerabilities",
          "deprecated": true
        }
      },
      "vulnerabilityAssessmentOnManagedInstanceMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Vulnerability assessment should be enabled on SQL Managed Instance",
          "description": "Audit each SQL Managed Instance which doesn't have recurring vulnerability assessment scans enabled. Vulnerability assessment can discover, track, and help you remediate potential database vulnerabilities."
        }
      },
      "vulnerabilityAssessmentOnServerMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Vulnerability assessment should be enabled on your SQL servers",
          "description": "Audit Azure SQL servers which do not have recurring vulnerability assessment scans enabled. Vulnerability assessment can discover, track, and help you remediate potential database vulnerabilities."
        }
      },
      "threatDetectionTypesOnManagedInstanceMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Advanced Threat Protection types should be set to 'All' in SQL Managed Instance advanced data security settings",
          "description": "It's recommended to enable all Advanced Threat Protection types on your SQL Managed Instance. Enabling all types protects against SQL injection, database vulnerabilities, and any other anomalous activities.",
          "deprecated": true
        }
      },
      "threatDetectionTypesOnServerMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Advanced Threat Protection types should be set to 'All' in SQL server Advanced Data Security settings",
          "description": "It is recommended to enable all Advanced Threat Protection types on your SQL servers. Enabling all types protects against SQL injection, database vulnerabilities, and any other anomalous activities.",
          "deprecated": true
        }
      },
      "adaptiveNetworkHardeningsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Adaptive network hardening recommendations should be applied on internet facing virtual machines",
          "description": "Enable or disable the monitoring of Internet-facing virtual machines for Network Security Group traffic hardening recommendations"
        }
      },
      "restrictAccessToManagementPortsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Management ports should be closed on your virtual machines",
          "description": "Enable or disable the monitoring of open management ports on Virtual Machines"
        }
      },
      "restrictAccessToAppServicesMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Access to App Services should be restricted",
          "description": "Enable or disable the monitoring of permissive network access to app-services",
          "deprecated": true
        }
      },
      "disableIPForwardingMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "IP Forwarding on your virtual machine should be disabled",
          "description": "Enable or disable the monitoring of IP forwarding on virtual machines"
        }
      },

      "ASCDependencyAgentAuditWindowsEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Audit Dependency Agent for Windows VMs monitoring",
          "description": "Enable or disable Dependency Agent for Windows VMs"
        }
      },
      "ASCDependencyAgentAuditLinuxEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Audit Dependency Agent for Linux VMs monitoring",
          "description": "Enable or disable Dependency Agent for Linux VMs"
        }
      },
      "AzureFirewallEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "All Internet traffic should be routed via your deployed Azure Firewall",
          "description": "Enable or disable All Internet traffic should be routed via your deployed Azure Firewall"
        }
      },
      "ArcWindowsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Log Analytics agent should be installed on your  Windows Azure Arc machines",
          "description": "Enable or disable Log Analytics agent should be installed on your  Windows Azure Arc machines"
        }
      },
      "ArcLinuxMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Log Analytics agent should be installed on your Linux Azure Arc machines",
          "description": "Enable or disable Log Analytics agent should be installed on your Linux Azure Arc machines"
        }
      },
      "keyVaultsAdvancedDataSecurityMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Defender for Key Vault should be enabled",
          "description": "Enable or disable Azure Defender for Key Vault"
        }
      },
      "sqlServersAdvancedDataSecurityMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Defender for Azure SQL Database servers should be enabled",
          "description": "Enable or disable Azure Defender for Azure SQL Database servers"
        }
      },
      "sqlServersVirtualMachinesAdvancedDataSecurityMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Defender for SQL servers on machines should be enabled",
          "description": "Enable or disable Azure Defender for SQL servers on Machines"
        }
      },
      "storageAccountsAdvancedDataSecurityMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Defender for Storage should be enabled",
          "description": "Enable or disable Azure Defender for storage"
        }
      },
      "appServicesAdvancedThreatProtectionMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Defender for App Services should be enabled",
          "description": "Enable or disable Azure Defender for App Service"
        }
      },
      "containerRegistryAdvancedThreatProtectionMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Defender for container registries should be enabled",
          "description": "Enable or disable Azure Defender for container registries"
        }
      },
      "kubernetesServiceAdvancedThreatProtectionMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Defender for Kubernetes should be enabled",
          "description": "Enable or disable Azure Defender for Kubernetes"
        }
      },
      "virtualMachinesAdvancedThreatProtectionMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Defender for servers should be enabled",
          "description": "Enable or disable Azure Defender for servers"
        }
      },
      "MustRunAsNonRootNamespaceExclusion": {
        "type": "Array",
        "Value": [
          "kube-system",
          "gatekeeper-system",
          "azure-arc"
        ],
        "metadata": {
          "displayName": "Kubernetes namespaces to exclude from monitoring of containers running as root user",
          "description": "List of Kubernetes namespaces to exclude from evaluation to monitoring of containers running as root users. To list multiple namespaces, use semicolons (;) to separate them."
        }
      },
      "MustRunAsNonRootNamespaceEffect": {
        "type": "string",
        "Value": "disabled",
        "allowedValues": [
          "audit",
          "deny",
          "disabled"
        ],
        "metadata": {
          "displayName": "Kubernetes containers should not be run as root user",
          "description": "Enable or disable monitoring of containers running as root user in Kubernetes nodes"
        }
      },
      "arcEnabledKubernetesClustersShouldHaveAzureDefendersExtensionInstalled": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Arc enabled Kubernetes clusters should have Azure Defender's extension installed",
          "description": "Enable or disable the monitoring of Arc enabled Kubernetes clusters without Azure Defender's extension installed"
        }
      },
      "containerRegistryVulnerabilityAssessmentEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Vulnerabilities in Azure Container Registry images should be remediated",
          "description": "Enable or disable monitoring of Azure container registries by Azure Security Center vulnerability assessment (powered by Qualys)"
        }
      },
      "disallowPublicBlobAccessEffect": {
        "type": "string",
        "Value": "disabled",
        "allowedValues": [
          "audit",
          "deny",
          "disabled"
        ],
        "metadata": {
          "displayName": "Storage account public access should be disallowed",
          "description": "Enable or disable reporting of Storage Accounts that allow public access"
        }
      },
      "managedIdentityShouldBeUsedInYourFunctionAppMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Managed identity should be used in your Function App",
          "description": "Use a managed identity for enhanced authentication security"
        }
      },
      "managedIdentityShouldBeUsedInYourWebAppMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Managed identity should be used in your Web App",
          "description": "Use a managed identity for enhanced authentication security"
        }
      },
      "ensureWEBAppHasClientCertificatesIncomingClientCertificatesSetToOnMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Ensure WEB app has Client Certificates Incoming client certificates set to On",
          "description": "Client certificates allow for the app to request a certificate for incoming requests. Only clients that have a valid certificate will be able to reach the app."
        }
      },
      "latestTLSVersionShouldBeUsedInYourAPIAppMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Latest TLS version should be used in your API App",
          "description": "Upgrade to the latest TLS version"
        }
      },
      "diagnosticLogsInAppServicesShouldBeEnabledMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Resource logs in App Services should be enabled",
          "description": "Audit enabling of resource logs on the app. This enables you to recreate activity trails for investigation purposes if a security incident occurs or your network is compromised"
        }
      },
      "managedIdentityShouldBeUsedInYourAPIAppMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Managed identity should be used in your API App",
          "description": "Use a managed identity for enhanced authentication security"
        }
      },
      "enforceSSLConnectionShouldBeEnabledForPostgresqlDatabaseServersMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Enforce SSL connection should be enabled for PostgreSQL database servers",
          "description": "Azure Database for PostgreSQL supports connecting your Azure Database for PostgreSQL server to client applications using Secure Sockets Layer (SSL). Enforcing SSL connections between your database server and your client applications helps protect against 'man in the middle' attacks by encrypting the data stream between the server and your application. This configuration enforces that SSL is always enabled for accessing your database server."
        }
      },
      "enforceSSLConnectionShouldBeEnabledForMysqlDatabaseServersMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Enforce SSL connection should be enabled for MySQL database servers",
          "description": "Azure Database for MySQL supports connecting your Azure Database for MySQL server to client applications using Secure Sockets Layer (SSL). Enforcing SSL connections between your database server and your client applications helps protect against 'man in the middle' attacks by encrypting the data stream between the server and your application. This configuration enforces that SSL is always enabled for accessing your database server."
        }
      },
      "latestTLSVersionShouldBeUsedInYourWebAppMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Latest TLS version should be used in your Web App",
          "description": "Upgrade to the latest TLS version"
        }
      },
      "latestTLSVersionShouldBeUsedInYourFunctionAppMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Latest TLS version should be used in your Function App",
          "description": "Upgrade to the latest TLS version"
        }
      },
      "privateEndpointShouldBeEnabledForPostgresqlServersMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Private endpoint should be enabled for PostgreSQL servers",
          "description": "Private endpoint connections enforce secure communication by enabling private connectivity to Azure Database for PostgreSQL. Configure a private endpoint connection to enable access to traffic coming only from known networks and prevent access from all other IP addresses, including within Azure."
        }
      },
      "privateEndpointShouldBeEnabledForMariadbServersMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Private endpoint should be enabled for MariaDB servers",
          "description": "Private endpoint connections enforce secure communication by enabling private connectivity to Azure Database for MariaDB. Configure a private endpoint connection to enable access to traffic coming only from known networks and prevent access from all other IP addresses, including within Azure."
        }
      },
      "privateEndpointShouldBeEnabledForMysqlServersMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Private endpoint should be enabled for MySQL servers",
          "description": "Private endpoint connections enforce secure communication by enabling private connectivity to Azure Database for MySQL. Configure a private endpoint connection to enable access to traffic coming only from known networks and prevent access from all other IP addresses, including within Azure."
        }
      },
      "sQLServersShouldBeConfiguredWithAuditingRetentionDaysGreaterThan90DaysMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "SQL servers should be configured with auditing retention days greater than 90 days",
          "description": "Audit SQL servers configured with an auditing retention period of less than 90 days."
        }
      },
      "fTPSOnlyShouldBeRequiredInYourFunctionAppMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "FTPS only should be required in your Function App",
          "description": "Enable FTPS enforcement for enhanced security"
        }
      },
      "fTPSShouldBeRequiredInYourWebAppMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "FTPS should be required in your Web App",
          "description": "Enable FTPS enforcement for enhanced security"
        }
      },
      "fTPSOnlyShouldBeRequiredInYourAPIAppMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "FTPS only should be required in your API App",
          "description": "Enable FTPS enforcement for enhanced security"
        }
      },
      "functionAppsShouldHaveClientCertificatesEnabledMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Function apps should have 'Client Certificates (Incoming client certificates)' enabled",
          "description": "Client certificates allow for the app to request a certificate for incoming requests. Only clients with valid certificates will be able to reach the app."
        }
      },
      "keyVaultsShouldHavePurgeProtectionEnabledMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Key vaults should have purge protection enabled",
          "description": "Malicious deletion of a key vault can lead to permanent data loss. A malicious insider in your organization can potentially delete and purge key vaults. Purge protection protects you from insider attacks by enforcing a mandatory retention period for soft deleted key vaults. No one inside your organization or Microsoft will be able to purge your key vaults during the soft delete retention period."
        }
      },
      "keyVaultsShouldHaveSoftDeleteEnabledMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Key vaults should have soft delete enabled",
          "description": "Deleting a key vault without soft delete enabled permanently deletes all secrets, keys, and certificates stored in the key vault. Accidental deletion of a key vault can lead to permanent data loss. Soft delete allows you to recover an accidentally deleted key vault for a configurable retention period."
        }
      },
      "azureCacheForRedisShouldResideWithinAVirtualNetworkMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Cache for Redis should reside within a virtual network",
          "description": "Azure Virtual Network deployment provides enhanced security and isolation for your Azure Cache for Redis, as well as subnets, access control policies, and other features to further restrict access.When an Azure Cache for Redis instance is configured with a virtual network, it is not publicly addressable and can only be accessed from virtual machines and applications within the virtual network."
        }
      },
      "storageAccountsShouldRestrictNetworkAccessUsingVirtualNetworkRulesMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Storage accounts should restrict network access using virtual network rules",
          "description": "Protect your storage accounts from potential threats using virtual network rules as a preferred method instead of IP-based filtering. Disabling IP-based filtering prevents public IPs from accessing your storage accounts."
        }
      },
      "containerRegistriesShouldNotAllowUnrestrictedNetworkAccessMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Container registries should not allow unrestricted network access",
          "description": "Azure container registries by default accept connections over the internet from hosts on any network. To protect your registries from potential threats, allow access from only specific public IP addresses or address ranges. If your registry doesn't have an IP/firewall rule or a configured virtual network, it will appear in the unhealthy resources. Learn more about Container Registry network rules here: https://aka.ms/acr/portal/public-network and here https://aka.ms/acr/vnet."
        }
      },
      "containerRegistriesShouldUsePrivateLinkMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Container registries should use private link",
          "description": "Azure Private Link lets you connect your virtual network to Azure services without a public IP address at the source or destination. The private link platform handles the connectivity between the consumer and services over the Azure backbone network.By mapping private endpoints to your container registries instead of the entire service, you'll also be protected against data leakage risks. Learn more at: https://aka.ms/acr/private-link."
        }
      },
      "appConfigurationShouldUsePrivateLinkMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "App Configuration should use private link",
          "description": "Azure Private Link lets you connect your virtual network to Azure services without a public IP address at the source or destination. The private link platform handles the connectivity between the consumer and services over the Azure backbone network. By mapping private endpoints to your app configuration instances instead of the entire service, you'll also be protected against data leakage risks. Learn more at: https://aka.ms/appconfig/private-endpoint."
        }
      },
      "azureEventGridDomainsShouldUsePrivateLinkMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Event Grid domains should use private link",
          "description": "Azure Private Link lets you connect your virtual network to Azure services without a public IP address at the source or destination. The private link platform handles the connectivity between the consumer and services over the Azure backbone network.By mapping private endpoints to your Event Grid domains instead of the entire service, you'll also be protected against data leakage risks.Learn more at: https://aka.ms/privateendpoints."
        }
      },
      "azureEventGridTopicsShouldUsePrivateLinkMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Event Grid topics should use private link",
          "description": "Azure Private Link lets you connect your virtual network to Azure services without a public IP address at the source or destination. The private link platform handles the connectivity between the consumer and services over the Azure backbone network. By mapping private endpoints to your topics instead of the entire service, you'll also be protected against data leakage risks. Learn more at: https://aka.ms/privateendpoints."
        }
      },
      "azureMachineLearningWorkspacesShouldBeEncryptedWithACustomerManagedKeyMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Machine Learning workspaces should be encrypted with a customer-managed key",
          "description": "Manage encryption at rest of your Azure Machine Learning workspace data with customer-managed keys. By default, customer data is encrypted with service-managed keys, but customer-managed keys are commonly required to meet regulatory compliance standards. Customer-managed keys enable the data to be encrypted with an Azure Key Vault key created and owned by you. You have full control and responsibility for the key lifecycle, including rotation and management. Learn more about customer-managed key encryption at https://aka.ms/azureml-workspaces-cmk."
        }
      },
      "azureMachineLearningWorkspacesShouldUsePrivateLinkMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Machine Learning workspaces should use private link",
          "description": "Azure Private Link lets you connect your virtual network to Azure services without a public IP address at the source or destination. The private link platform handles the connectivity between the consumer and services over the Azure backbone network. By mapping private endpoints to your Azure Machine Learning workspaces instead of the entire service, you'll also be protected against data leakage risks. Learn more at: https://aka.ms/azureml-workspaces-privatelink."
        }
      },
      "webApplicationFirewallShouldBeEnabledForAzureFrontDoorServiceServiceMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Web Application Firewall (WAF) should be enabled for Azure Front Door Service service",
          "description": "Deploy Azure Web Application Firewall (WAF) in front of public facing web applications for additional inspection of incoming traffic. Web Application Firewall (WAF) provides centralized protection of your web applications from common exploits and vulnerabilities such as SQL injections, Cross-Site Scripting, local and remote file executions. You can also restrict access to your web applications by countries, IP address ranges, and other http(s) parameters via custom rules."
        }
      },
      "webApplicationFirewallShouldBeEnabledForApplicationGatewayMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Web Application Firewall (WAF) should be enabled for Application Gateway",
          "description": "Deploy Azure Web Application Firewall (WAF) in front of public facing web applications for additional inspection of incoming traffic. Web Application Firewall (WAF) provides centralized protection of your web applications from common exploits and vulnerabilities such as SQL injections, Cross-Site Scripting, local and remote file executions. You can also restrict access to your web applications by countries, IP address ranges, and other http(s) parameters via custom rules."
        }
      },
      "publicNetworkAccessShouldBeDisabledForMySqlServersMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Public network access should be disabled for MySQL servers",
          "description": "Disable the public network access property to improve security and ensure your Azure Database for MySQL can only be accessed from a private endpoint. This configuration strictly disables access from any public address space outside of Azure IP range, and denies all logins that match IP or virtual network-based firewall rules."
        }
      },
      "bringYourOwnKeyDataProtectionShouldBeEnabledForMySqlServersMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "MySQL servers should use customer-managed keys to encrypt data at rest",
          "description": "Use customer-managed keys to manage the encryption at rest of your MySQL servers. By default, the data is encrypted at rest with service-managed keys, but customer-managed keys are commonly required to meet regulatory compliance standards. Customer-managed keys enable the data to be encrypted with an Azure Key Vault key created and owned by you. You have full control and responsibility for the key lifecycle, including rotation and management."
        }
      },
      "vmImageBuilderTemplatesShouldUsePrivateLinkMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "VM Image Builder templates should use private link",
          "description": "Audit VM Image Builder templates that do not have a virtual network configured. When a virtual network is not configured, a public IP is created and used instead which may directly expose resources to the internet and increase the potential attack surface."
        }
      },
      "firewallShouldBeEnabledOnKeyVaultMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Firewall should be enabled on Key Vault",
          "description": "Key vault's firewall prevents unauthorized traffic from reaching your key vault and provides an additional layer of protection for your secrets. Enable the firewall to make sure that only traffic from allowed networks can access your key vault."
        }
      },
      "privateEndpointShouldBeConfiguredForKeyVaultMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Private endpoint should be configured for Key Vault",
          "description": "Private link provides a way to connect Key Vault to your Azure resources without sending traffic over the public internet. Private link provides defense in depth protection against data exfiltration."
        }
      },
      "storageAccountShouldUseAPrivateLinkConnectionMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Storage account should use a private link connection",
          "description": "Private links enforce secure communication, by providing private connectivity to the storage account"
        }
      },
      "authenticationToLinuxMachinesShouldRequireSSHKeysMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Authentication to Linux machines should require SSH keys",
          "description": "Although SSH itself provides an encrypted connection, using passwords with SSH still leaves the VM vulnerable to brute-force attacks. The most secure option for authenticating to an Azure Linux virtual machine over SSH is with a public-private key pair, also known as SSH keys. Learn more: https://docs.microsoft.com/azure/virtual-machines/linux/create-ssh-keys-detailed."
        }
      },
      "privateEndpointConnectionsOnAzureSQLDatabaseShouldBeEnabledMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Private endpoint connections on Azure SQL Database should be enabled",
          "description": "Private endpoint connections enforce secure communication by enabling private connectivity to Azure SQL Database."
        }
      },
      "publicNetworkAccessOnAzureSQLDatabaseShouldBeDisabledMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Public network access on Azure SQL Database should be disabled",
          "description": "Disabling the public network access property improves security by ensuring your Azure SQL Database can only be accessed from a private endpoint. This configuration denies all logins that match IP or virtual network based firewall rules."
        }
      },
      "ensureAPIAppHasClientCertificatesIncomingClientCertificatesSetToOnMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Ensure API app has Client Certificates Incoming client certificates set to On",
          "description": "Client certificates allow for the app to request a certificate for incoming requests. Only clients that have a valid certificate will be able to reach the app."
        }
      },
      "kubernetesClustersShouldBeAccessibleOnlyOverHTTPSMonitoringEffect": {
        "type": "string",
        "Value": "disabled",
        "allowedValues": [
          "audit",
          "deny",
          "disabled"
        ],
        "metadata": {
          "displayName": "Kubernetes clusters should be accessible only over HTTPS",
          "description": "Use of HTTPS ensures authentication and protects data in transit from network layer eavesdropping attacks. This capability is currently generally available for Kubernetes Service (AKS), and in preview for AKS Engine and Azure Arc enabled Kubernetes. For more info, visit https://aka.ms/kubepolicydoc"
        }
      },
      "kubernetesClustersShouldBeAccessibleOnlyOverHTTPSExcludedNamespaces": {
        "type": "Array",
        "Value": [
          "kube-system",
          "gatekeeper-system",
          "azure-arc"
        ],
        "metadata": {
          "displayName": "Namespace exclusions",
          "description": "List of Kubernetes namespaces to exclude from policy evaluation."
        }
      },
      "windowsWebServersShouldBeConfiguredToUseSecureCommunicationProtocolsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Windows web servers should be configured to use secure communication protocols",
          "description": "To protect the privacy of information communicated over the Internet, your web servers should use the latest version of the industry-standard cryptographic protocol, Transport Layer Security (TLS). TLS secures communications over a network by using security certificates to encrypt a connection between machines."
        }
      },
      "windowsWebServersShouldBeConfiguredToUseSecureCommunicationProtocolsMinimumTLSVersion": {
        "type": "string",
        "Value": "1.1",
        "allowedValues": [
          "1.1",
          "1.2"
        ],
        "metadata": {
          "displayName": "Minimum TLS version",
          "description": "The minimum TLS protocol version that should be enabled. Windows web servers with lower TLS versions will be marked as non-compliant."
        }
      },
      "aPIManagementServicesShouldUseAVirtualNetworkMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "metadata": {
          "displayName": "API Management services should use a virtual network",
          "description": "Azure Virtual Network deployment provides enhanced security, isolation and allows you to place your API Management service in a non-internet routable network that you control access to. These networks can then be connected to your on-premises networks using various VPN technologies, which enables access to your backend services within the network and/or on-premises. The developer portal and API gateway, can be configured to be accessible either from the Internet or only within the virtual network."
        }
      },
      "azureCosmosDBAccountsShouldHaveFirewallRulesMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Cosmos DB accounts should have firewall rules",
          "description": "Firewall rules should be defined on your Azure Cosmos DB accounts to prevent traffic from unauthorized sources. Accounts that have at least one IP rule defined with the virtual network filter enabled are deemed compliant. Accounts disabling public access are also deemed compliant."
        }
      },
      "networkWatcherShouldBeEnabledMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Network Watcher should be enabled",
          "description": "Network Watcher is a regional service that enables you to monitor and diagnose conditions at a network scenario level in, to, and from Azure. Scenario level monitoring enables you to diagnose problems at an end to end network level view. Network diagnostic and visualization tools available with Network Watcher help you understand, diagnose, and gain insights to your network in Azure."
        }
      },
      "networkWatcherShouldBeEnabledListOfLocations": {
        "type": "Array",
        "Value": [],
        "metadata": {
          "displayName": "List of regions where Network Watcher should be enabled",
          "description": "To see a complete list of regions, run the PowerShell command Get-AzLocation",
          "strongType": "location",
          "deprecated": true
        }
      },
      "networkWatcherShouldBeEnabledResourceGroupName": {
        "type": "String",
        "Value": "NetworkWatcherRG",
        "metadata": {
          "displayName": "Name of the resource group for Network Watcher",
          "description": "Name of the resource group where Network Watchers are located"
        }
      },
      "AzureDefenderForResourceManagerShouldBeEnabledMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Defender for Resource Manager should be enabled",
          "description": "Azure Defender for Resource Manager automatically monitors the resource management operations in your organization. Azure Defender detects threats and alerts you about suspicious activity. Learn more about the capabilities of Azure Defender for Resource Manager at https://aka.ms/defender-for-resource-manager . Enabling this Azure Defender plan results in charges. Learn about the pricing details per region on Security Center's pricing page: https://aka.ms/pricing-security-center ."
        }
      },
      "AzureDefenderForDNSShouldBeEnabledMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Azure Defender for DNS should be enabled",
          "description": "Azure Defender for DNS provides an additional layer of protection for your cloud resources by continuously monitoring all DNS queries from your Azure resources. Azure Defender alerts you about suspicious activity at the DNS layer. Learn more about the capabilities of Azure Defender for DNS at https://aka.ms/defender-for-dns . Enabling this Azure Defender plan results in charges. Learn about the pricing details per region on Security Center's pricing page: https://aka.ms/pricing-security-center ."
        }
      },
      "KubernetesClustersShouldNotUseTheDefaultNamespaceMonitoringEffect": {
        "type": "string",
        "Value": "disabled",
        "allowedValues": [
          "audit",
          "deny",
          "disabled"
        ],
        "metadata": {
          "displayName": "Kubernetes clusters should not use the default namespace",
          "description": "Prevent usage of the default namespace in Kubernetes clusters to protect against unauthorized access for ConfigMap, Pod, Secret, Service, and ServiceAccount resource types. For more information, see https://aka.ms/kubepolicydoc."
        }
      },
      "KubernetesClustersShouldDisableAutomountingAPICredentialsMonitoringEffect": {
        "type": "string",
        "Value": "disabled",
        "allowedValues": [
          "audit",
          "deny",
          "disabled"
        ],
        "metadata": {
          "displayName": "Kubernetes clusters should disable automounting API credentials",
          "description": "Disable automounting API credentials to prevent a potentially compromised Pod resource to run API commands against Kubernetes clusters. For more information, see https://aka.ms/kubepolicydoc."
        }
      },
      "KubernetesClustersShouldNotGrantCAPSYSADMINSecurityCapabilitiesMonitoringEffect": {
        "type": "string",
        "Value": "disabled",
        "allowedValues": [
          "audit",
          "deny",
          "disabled"
        ],
        "metadata": {
          "displayName": "Kubernetes clusters should not grant CAPSYSADMIN security capabilities",
          "description": "To reduce the attack surface of your containers, restrict CAP_SYS_ADMIN Linux capabilities. For more information, see https://aka.ms/kubepolicydoc."
        }
      },
      "GuestAttestationExtensionShouldBeInstalledOnSupportedLinuxVirtualMachinesMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Guest Attestation extension should be installed on supported Linux virtual machines",
          "description": "Install Guest Attestation extension on supported Linux virtual machines to allow Azure Security Center to proactively attest and monitor the boot integrity. Once installed, boot integrity will be attested via Remote Attestation. This assessment only applies to trusted launch enabled Linux virtual machines."
        }
      },
      "GuestAttestationExtensionShouldBeInstalledOnSupportedLinuxVirtualMachinesScaleSetsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Guest Attestation extension should be installed on supported Linux virtual machines scale sets",
          "description": "Install Guest Attestation extension on supported Linux virtual machines scale sets to allow Azure Security Center to proactively attest and monitor the boot integrity. Once installed, boot integrity will be attested via Remote Attestation. This assessment only applies to trusted launch enabled Linux virtual machine scale sets."
        }
      },
      "GuestAttestationExtensionShouldBeInstalledOnSupportedWindowsVirtualMachinesMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Guest Attestation extension should be installed on supported Windows virtual machines",
          "description": "Install Guest Attestation extension on supported virtual machines to allow Azure Security Center to proactively attest and monitor the boot integrity. Once installed, boot integrity will be attested via Remote Attestation. This assessment only applies to trusted launch enabled virtual machines."
        }
      },
      "GuestAttestationExtensionShouldBeInstalledOnSupportedWindowsVirtualMachinesScaleSetsMonitoringEffect": {
        "type": "string",
        "Value": "Disabled",
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "metadata": {
          "displayName": "Guest Attestation extension should be installed on supported Windows virtual machines scale sets",
          "description": "Install Guest Attestation extension on supported virtual machines scale sets to allow Azure Security Center to proactively attest and monitor the boot integrity. Once installed, boot integrity will be attested via Remote Attestation. This assessment only applies to trusted launch enabled virtual machine scale sets."
        }
      }
}
PARAMETERS


}