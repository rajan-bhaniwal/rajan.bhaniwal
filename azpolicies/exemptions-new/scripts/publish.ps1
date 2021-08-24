Param(
  [Parameter(Mandatory=$true,Position=1,
                HelpMessage = 'Full Runbook Path')][string]$runbookPath,
  [Parameter(Mandatory=$false,Position=2,
                HelpMessage = 'Automation Resource Group')][string]$automationAccountRSG = "WEU-RSG-PRIV-DNS",
  [Parameter(Mandatory=$false,Position=3,
                HelpMessage = 'Automation Name')][string]$automationAccountName = "testautopol",
  [Parameter(Mandatory=$false,Position=4,
                HelpMessage = 'Runbook Name')][string]$runbookName = "rb-policy-exemption",
  [Parameter(Mandatory=$false,Position=5,
                HelpMessage = 'Automation Subscription Name')][string]$subscriptionName = "rack-multi-hub-nonprod"
)


#select subscription 
Select-AzSubscription $subscriptionName

# Upload and Publish Runbook
Import-AzAutomationRunbook -Name $runbookName -Path $runbookPath -ResourceGroupName $automationAccountRSG -AutomationAccountName $automationAccountName -Type PowerShell -Force
Publish-AzAutomationRunbook -Name $runbookName -ResourceGroupName $automationAccountRSG -AutomationAccountName $automationAccountName  