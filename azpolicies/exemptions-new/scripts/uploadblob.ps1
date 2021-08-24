Param(
  [Parameter(Mandatory=$true,Position=1,
                HelpMessage = 'Full CSV File Path')][string]$csvPath,
  [Parameter(Mandatory=$false,Position=2,
                HelpMessage = 'Storage Resource Group')][string]$storagersg = "WEU-RSG-PRIV-DNS",
  [Parameter(Mandatory=$false,Position=3,
                HelpMessage = 'Storage Name')][string]$storagename = "policyexemptions",
  [Parameter(Mandatory=$false,Position=4,
                HelpMessage = 'Storage Name')][string]$storagecontainer = "policy",
  [Parameter(Mandatory=$false,Position=5,
                HelpMessage = 'Storage Subscription Name')][string]$subscriptionname = "rack-multi-hub-nonprod"
)


#select subscription 
Select-AzSubscription $subscriptionname

#Get storage context
$saContext = (Get-AzStorageAccount -Name $storagename -ResourceGroupName $storagersg).Context

# upload a file to the default account (inferred) access tier
Set-AzStorageBlobContent -File $csvPath `
  -Container $storagecontainer `
  -Blob "policy-exemptions.csv" `
  -Context $saContext -Force