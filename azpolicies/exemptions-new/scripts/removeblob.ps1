Param(
  [Parameter(Mandatory=$true,Position=1,
                HelpMessage = 'BlobName')][string]$blobName,
  [Parameter(Mandatory=$true,Position=2,
                HelpMessage = 'Storage Resource Group')][string]$storagersg,
  [Parameter(Mandatory=$true,Position=3,
                HelpMessage = 'Storage Name')][string]$storageName,
  [Parameter(Mandatory=$true,Position=4,
                HelpMessage = 'Storage Name')][string]$storageContainer,
  [Parameter(Mandatory=$true,Position=5,
                HelpMessage = 'Storage Subscription Name')][string]$subscriptionName
)


#select subscription 
Select-AzSubscription $subscriptionName

#Get storage context
$saContext = (Get-AzStorageAccount -Name $storageName -ResourceGroupName $storagersg).Context

# Remove storage blob
Remove-AzStorageBlob -Blob $blobName -Container $storageContainer -Context $saContext -Force