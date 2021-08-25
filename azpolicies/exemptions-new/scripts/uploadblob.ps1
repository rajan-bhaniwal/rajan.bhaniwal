Param(
  [Parameter(Mandatory=$true,Position=1,
                HelpMessage = 'Full CSV File Path')][string]$csvPath,
  [Parameter(Mandatory=$false,Position=2,
                HelpMessage = 'Storage Resource Group')][string]$storagersg,
  [Parameter(Mandatory=$false,Position=3,
                HelpMessage = 'Storage Name')][string]$storageName,
  [Parameter(Mandatory=$false,Position=4,
                HelpMessage = 'Storage Name')][string]$storageContainer,
  [Parameter(Mandatory=$true,Position=5,
                HelpMessage = 'BlobName')][string]$blobName,
  [Parameter(Mandatory=$false,Position=6,
                HelpMessage = 'Storage Subscription Name')][string]$subscriptionName
)


#select subscription 
Select-AzSubscription $subscriptionname

#Get storage context
$saContext = (Get-AzStorageAccount -Name $storagename -ResourceGroupName $storagersg).Context

# upload a file to the default account (inferred) access tier
Set-AzStorageBlobContent -File $csvPath `
  -Container $storagecontainer `
  -Blob $blobName `
  -Context $saContext -Force