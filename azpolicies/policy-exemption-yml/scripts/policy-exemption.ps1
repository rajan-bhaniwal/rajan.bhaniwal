Param(
  [Parameter(Mandatory=$false,Position=1,
                HelpMessage = 'CSV File Path')][string]$csvPath = "C:\test\policyExemption.csv",
  [Parameter(Mandatory=$false,Position=2,
                HelpMessage = 'Storage Resource Group')][string]$storageRSG = "WEU-RSG-PRIV-DNS",
  [Parameter(Mandatory=$false,Position=3,
                HelpMessage = 'Storage Name')][string]$storageName = "storageaccountweurs80f1",
  [Parameter(Mandatory=$false,Position=4,
                HelpMessage = 'Storage Table Name')][string]$tableName = "policyExemptions1"
)

#select subscription 
Select-AzSubscription rack-multi-hub-nonprod

#Import CSV File
$policyExemptions = Import-Csv $csvPath

#Set Date Format
$dataTimeFormat = "MM/dd/yyyy HH:mm:ss"

#Generate Random GUID
$guid = (new-guid).guid.Substring(0,8)

#Error action 
$ErrorActionPreference = "Stop"

function addPolicyExemptions ($policyExemption)
{
   try{

       #Get Policy Assignment (Ensure to select subscription where Assignments exists)
        $policyAssignment = (Get-AzpolicyAssignment | Where-Object {$_.name -eq $policyExemption.policyAssignmentName})
        $dateAdded = (Get-Date).ToString($dataTimeFormat)
        $policyExemptionExpiry = (Get-Date).AddDays($policyExemption.ExpiryDays).ToString($dataTimeFormat)
        $policyExemptionName = "exemption-"+ $guid + "-" + $policyAssignment.Name
        $policyExemptionDescription = "policy Exemption Jira ID:" + $policyExemption.JiraID

        Write-Host "Adding Policy Exemption $($PolicyExemptionName)"
        $applypolicyExemption = New-AzpolicyExemption -Name $policyExemptionName -policyAssignment $policyAssignment `
        -Scope $policyExemption.ResourceID -ExemptionCategory "Waiver" -ExpiresOn $policyExemptionExpiry -Description $policyExemptionDescription

        return @{"policyAssignment"=$policyAssignment;"dateAdded"=$dateAdded;"policyExemptionExpiry"=$policyExemptionExpiry;`
        "policyExemptionName"=$policyExemptionName;"policyExemptionDescription"=$policyExemptionDescription;"applypolicyExemption"=$applypolicyExemption}
    }
    Catch
    {
        $ErrMsg = "Powershell exception :: Line# $($_.InvocationInfo.ScriptLineNumber) :: $($_.Exception.Message)"
        Write-Output "Script failed to run"
        Write-Output $ErrMsg
    }
}

function addPolicyExemptionsToTable ($policyExemption,$outputPolicyExemption)
{
   try{
        #Get Storage context where tables exists
        $saContext = (Get-AzStorageAccount -ResourceGroupName $storageRSG -Name $storageName).Context
        $saTable = (Get-AzStorageTable -Name $tableName -Context $saContext).CloudTable
        $partitionKey = "partition1"
        $rowKey = $guid

        Write-Host "Adding Policy Exemption To Table $($storageName): $($tableName)"
        $writetoTable = Add-AzTableRow -Table $saTable -PartitionKey $partitionKey -RowKey $rowKey -property `
        @{"resourceID"=$policyExemption.ResourceId;"datedadded"=$outputPolicyExemption.dateAdded;"expiredate"=$outputPolicyExemption.policyExemptionExpiry;`
        "description"=$outputPolicyExemption.policyExemptionDescription;"exemptionCategory"="Waiver";"policyassignmentID"= $outputPolicyExemption.policyAssignment.PolicyAssignmentId;`
        "ticketRef"=$policyExemption.JiraID;"exemptionname"=$outputPolicyExemption.policyExemptionName} 


        return $writetoTable
    }
    Catch
    {
        $ErrMsg = "Powershell exception :: Line# $($_.InvocationInfo.ScriptLineNumber) :: $($_.Exception.Message)"
        Write-Output "Script failed to run"
        Write-Output $ErrMsg
    }
}


foreach ($policyExemption in $policyExemptions)
{
    try 
    {
        #Add Policy Exemption on Azure Resource, calling 'addPolicyExemptions' function 
        $outputPolicyExemption = addPolicyExemptions -policyExemption $policyExemption

        if ($outputPolicyExemption.applypolicyExemption.ResourceId -eq $null)
        {
          Write-Output "Exemption creation failed"
        }
        else
        {
            #Add Policy Exemption on Azure Table Storage, calling 'addPolicyExemptionsToTable' function 
            $outputPolicyExemptionTable = addPolicyExemptionsToTable -policyExemption $policyExemption -outputPolicyExemption $outputPolicyExemption

            #Clear CSV File
            (Get-Content $csvPath |  Select-Object -First 1) | Out-File $csvPath -Force
        }
    }
    Catch
    {
        $ErrMsg = "Powershell exception :: Line# $($_.InvocationInfo.ScriptLineNumber) :: $($_.Exception.Message)"
        Write-Output "Script failed to run"
        Write-Output $ErrMsg
    }
}

$outputPolicyExemption
$outputPolicyExemptionTable
