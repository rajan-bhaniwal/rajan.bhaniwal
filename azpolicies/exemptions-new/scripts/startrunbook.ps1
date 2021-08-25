Param(
  [Parameter(Mandatory=$true,Position=1,
                HelpMessage = 'Automation Resource Group')][string]$automationAccountRSG,
  [Parameter(Mandatory=$true,Position=2,
                HelpMessage = 'Automation Name')][string]$automationAccountName,
  [Parameter(Mandatory=$true,Position=3,
                HelpMessage = 'Runbook Name')][string]$runbookName,
  [Parameter(Mandatory=$true,Position=3,
                HelpMessage = 'Runbook Parameters')][hashtable]$runbookParameters,
  [Parameter(Mandatory=$true,Position=4,
                HelpMessage = 'Automation Subscription Name')][string]$subscriptionName
)


#select subscription 
Select-AzSubscription $subscriptionName

#Get automation account object
$automationAccount = Get-AzAutomationAccount -Name $automationAccountName -ResourceGroupName $automationAccountRSG 

#start exemption runbook
$job = Start-AzAutomationRunbook -Name $runbookName -AutomationAccountName $automationAccount.AutomationAccountName -ResourceGroupName $automationAccount.ResourceGroupName -Parameters $runbookParameters 

#Get Job Status, wait for completion or failure
$jobResult = Get-AzAutomationJob -Id $job.JobId -AutomationAccountName $automationAccount.AutomationAccountName -ResourceGroupName $automationAccount.ResourceGroupName
while ($jobResult.Status -eq 'New' -or $jobResult.Status -eq 'Running'){
    $jobResult = Get-AzAutomationJob -Id $job.JobId -AutomationAccountName $automationAccount.AutomationAccountName -ResourceGroupName $automationAccount.ResourceGroupName
    write-output "waiting for automation runbook job to complete"
    start-sleep -Seconds 3
}
$output = Get-AzAutomationJobOutput -AutomationAccountName $automationAccount.AutomationAccountName -Id $job.JobId -ResourceGroupName $automationAccount.ResourceGroupName -Stream "Any"

Write-Output "Job Status:$($jobResult.Status)"

Write-Output "Job Output:$($output.Summary)"