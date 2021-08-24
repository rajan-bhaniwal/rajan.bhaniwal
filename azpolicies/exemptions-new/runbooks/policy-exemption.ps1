Param(
  [Parameter(Mandatory=$false,Position=1,
                HelpMessage = 'CSV File Name')][string]$csvName = "policy-exemptions.csv",
  [Parameter(Mandatory=$false,Position=1,
                HelpMessage = 'CSV File Path')][string]$csvPath = "policy-exemptions.csv",
  [Parameter(Mandatory=$false,Position=2,
                HelpMessage = 'SQL Server Name')][string]$sqlServer = "sqlserverpolicy.database.windows.net",
  [Parameter(Mandatory=$false,Position=3,
                HelpMessage = 'SQL DB Name')][string]$sqlDBName = "policyexemption",
  [Parameter(Mandatory=$false,Position=4,
                HelpMessage = 'SQL Table Name')][string]$sqlTableName = "policyexemptions",
  [Parameter(Mandatory=$false,Position=5,
                HelpMessage = 'Storage Resource Group')][string]$storagersg = "WEU-RSG-PRIV-DNS",
  [Parameter(Mandatory=$false,Position=6,
                HelpMessage = 'Storage Name')][string]$storagename = "policyexemptions",
  [Parameter(Mandatory=$false,Position=7,
                HelpMessage = 'Storage Name')][string]$storagecontainer = "policy",
  [Parameter(Mandatory=$false,Position=8,
                HelpMessage = 'Storage Subscrption Name')][string]$storageSubscription = "rack-multi-hub-nonprod"
)

#Get access token for SQLDB (Managed Identity)
$response = Invoke-WebRequest -Uri 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fdatabase.windows.net%2F' -Method GET -Headers @{Metadata="true"} -UseBasicParsing
$content = $response.Content | ConvertFrom-Json
$AccessToken = $content.access_token

#select subscription 
Select-AzSubscription $storageSubscription 


#Set Date Format
$dataTimeFormat = "MM/dd/yyyy HH:mm:ss"

#Generate Random GUID
$guid = (new-guid).guid.Substring(0,8)

#Error action 
$ErrorActionPreference = "Stop"

function getcsvblob
{

   try{

        #Import CSV File
        $saContext = (Get-AzStorageAccount -Name $storagename -ResourceGroupName $storagersg).Context

        $blobtemppath = "$env:temp\policy$guid"
        # download the csv file to the temp folder in runbook
        if( -Not (Test-Path -Path $blobtemppath ) )
        {
            $tempfolder= New-Item -ItemType directory -Path $blobtemppath
        }
        $blobcontent = Get-AzStorageBlobContent -Blob $csvName -Container $storagecontainer -Destination $blobtemppath -Context $saContext -Force

        $csvcontent = Import-Csv "$blobtemppath\$csvName"

        return $csvcontent
    }
    Catch
    {
        $ErrMsg = "Powershell exception :: Line# $($_.InvocationInfo.ScriptLineNumber) :: $($_.Exception.Message)"
        Write-Output "Script failed to run"
        Write-Output $ErrMsg
    }
}

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

#call function to pull CSV
$policyExemptions = getcsvblob

if ($policyExemptions -eq $null)
{

  Write-Host "CSV file is missing in Blob Storage, please check.."
}
else
{

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
}
$outputPolicyExemption
$outputPolicyExemptionTable
