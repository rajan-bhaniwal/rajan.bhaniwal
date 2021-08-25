Param(
  [Parameter(Mandatory=$true,Position=1,
                HelpMessage = 'Full Runbook Path')][string]$runbookPath,
  [Parameter(Mandatory=$true,Position=2,
                HelpMessage = 'Automation Resource Group')][string]$automationAccountRSG,
  [Parameter(Mandatory=$true,Position=3,
                HelpMessage = 'Automation Name')][string]$automationAccountName,
  [Parameter(Mandatory=$true,Position=4,
                HelpMessage = 'Runbook Name')][string]$runbookName,
  [Parameter(Mandatory=$true,Position=5,
                HelpMessage = 'Automation Subscription Name')][string]$subscriptionName
)


#select subscription 
Select-AzSubscription $subscriptionName

# Upload and Publish Runbook
Import-AzAutomationRunbook -Name $runbookName -Path $runbookPath -ResourceGroupName $automationAccountRSG -AutomationAccountName $automationAccountName -Type PowerShell -Force
Publish-AzAutomationRunbook -Name $runbookName -ResourceGroupName $automationAccountRSG -AutomationAccountName $automationAccountName  