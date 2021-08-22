Param(
  [Parameter(Mandatory=$false,Position=1,
                HelpMessage = 'CSV File Path')][string]$csvPath = "C:\test\policyExemption.csv",
  [Parameter(Mandatory=$false,Position=2,
                HelpMessage = 'SQL Server Name')][string]$sqlServer = "sqlserverpolicy.database.windows.net",
  [Parameter(Mandatory=$false,Position=3,
                HelpMessage = 'SQL DB Name')][string]$sqlDBName = "policyexemption",
  [Parameter(Mandatory=$false,Position=4,
                HelpMessage = 'SQL Table Name')][string]$sqlTableName = "policyexemptions"
)

#Get access token for SQLDB (Managed Identity)
$response = Invoke-WebRequest -Uri 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fdatabase.windows.net%2F' -Method GET -Headers @{Metadata="true"} -UseBasicParsing
$content = $response.Content | ConvertFrom-Json
$AccessToken = $content.access_token

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

function addPolicyExemptionsToSQLdb ($policyExemption,$outputPolicyExemption)
{
   try{
       
       Write-Host "Adding Policy Exemption To SQLDB $($sqlServer): $($sqlDBName):$($sqlTableName)"
$query = @"
INSERT INTO $($sqlTableName) (resourceID,dateadded,expirydate,description,exemptionCategory,policyassignmentID,ticketRef,exemptionname) 
VALUES ('$($policyExemption.ResourceId)','$($outputPolicyExemption.dateAdded)','$($outputPolicyExemption.policyExemptionExpiry)','$($outputPolicyExemption.policyExemptionDescription)','Waiver','$($outputPolicyExemption.policyAssignment.PolicyAssignmentId)',
'$($policyExemption.JiraID)','$($outputPolicyExemption.policyExemptionName)');
"@
        $writetoTable = Invoke-Sqlcmd -ServerInstance $sqlserver -Database $sqlDBName -Query $Query -AccessToken $AccessToken -OutputAs DataTables

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
            #Add Policy Exemption on Azure SQLDB, calling 'addPolicyExemptionsToSQLDB' function 
            $outputPolicyExemptionTable = addPolicyExemptionsToSQLdb -policyExemption $policyExemption -outputPolicyExemption $outputPolicyExemption

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
