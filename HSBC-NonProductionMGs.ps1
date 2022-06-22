<#
.SYNOPSIS
 
A script used to create a management groups tree structure
 
.DESCRIPTION
 
A script used to create a management groups tree structure.
 
.NOTES
 
Filename:       HSBC-NonProductionMgs.ps1
Created:        22/06/2022
Last modified:  22/06/2022
Author:         Rajan Bhaniwal
PowerShell:     Azure PowerShell or Azure Cloud Shell
Version:        Install latest Azure PowerShell modules

 
 
.EXAMPLE
 
.\HSBC-NonProductionMgs.ps1
 
#>
 
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Variables
 
$environment = "NonProduction" # <your company full name here> Example: "myhcjourney"
$environmentShortName ="NonProd" # <your company short name here> Best is to use a three letter abbreviation. Example: "myh"
 
$companyManagementGroupName = "HSBC-" + $environment

 
$platformManagementGroupName = $environmentShortName + "-Platform"

$landingZonesManagementGroupName = $environmentShortName + "-Landing-Zones"

$stagingManagementGroupName = $environmentShortName + "-Staging"

$decommissionedManagementGroupName = $environmentShortName + "-Decommissioned"

 
$managementManagementGroupName = $environmentShortName + "-Management"

$connectivityManagementGroupName = $environmentShortName + "-Connectivity"

$identityManagementGroupName = $environmentShortName + "-Identity"

 
$corpManagementGroupName = $environmentShortName + "-Corp"

$corpExternalManagementGroupName = $environmentShortName + "-Corp-external"

$ExternalManagementGroupName = $environmentShortName + "-External"

$VDIManagementGroupName = $environmentShortName + "-VDI"
 
 
$global:currenttime= Set-PSBreakpoint -Variable currenttime -Mode Read -Action {$global:currenttime= Get-Date -UFormat "%A %m/%d/%Y %R"}
$foregroundColor1 = "Red"
$foregroundColor2 = "Yellow"
$writeEmptyLine = "`n"
$writeSeperatorSpaces = " - "

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Suppress breaking change warning messages
 
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"
 
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Create Company management group
 
New-AzManagementGroup -GroupName $companyManagementGroupName -DisplayName $companyManagementGroupName | Out-Null
 
# Store Company management group in a variable
$companyParentGroup = Get-AzManagementGroup -GroupName $companyManagementGroupName
 
Write-Host ($writeEmptyLine + "# Company management group $companyManagementGroupName created" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
 
 sleep -Seconds 30
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Create Top management groups
 
# Create Platform management group
New-AzManagementGroup -GroupName $platformManagementGroupName -DisplayName $platformManagementGroupName -ParentObject $companyParentGroup | Out-Null
 
# Create Landing Zones management group
New-AzManagementGroup -GroupName $landingZonesManagementGroupName -DisplayName $landingZonesManagementGroupName -ParentObject $companyParentGroup | Out-Null
 
# Create Staging management group
New-AzManagementGroup -GroupName $stagingManagementGroupName -DisplayName $stagingManagementGroupName -ParentObject $companyParentGroup | Out-Null
 
# Create Decomission management group
New-AzManagementGroup -GroupName $decommissionedManagementGroupName -DisplayName $decommissionedManagementGroupName -ParentObject $companyParentGroup | Out-Null
 
# Store specific Top management groups in variables
$platformParentGroup = Get-AzManagementGroup -GroupName $platformManagementGroupName
$landingZonesParentGroup = Get-AzManagementGroup -GroupName $landingZonesManagementGroupName
 
Write-Host ($writeEmptyLine + "# Top management groups $platformManagementGroupName, $landingZonesManagementGroupName, $stagingManagementGroupName, and `
$decommissionedManagementGroupName created" + $writeSeperatorSpaces + $currentTime) -foregroundcolor $foregroundColor2 $writeEmptyLine
 
 sleep -Seconds 30
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Create Platform management groups
 
# Create Management management group
New-AzManagementGroup -GroupName $managementManagementGroupName -DisplayName $managementManagementGroupName -ParentObject $platformParentGroup | Out-Null
 
# Create Connectivity management group
New-AzManagementGroup -GroupName $connectivityManagementGroupName -DisplayName $connectivityManagementGroupName -ParentObject $platformParentGroup | Out-Null
 
# Create Identity management group
New-AzManagementGroup -GroupName $identityManagementGroupName -DisplayName $identityManagementGroupName -ParentObject $platformParentGroup | Out-Null
 
Write-Host ($writeEmptyLine + "# Platform management groups $managementManagementGroupName, $connectivityManagementGroupName and `
$identityManagementGroupName created" + $writeSeperatorSpaces + $currentTime) -foregroundcolor $foregroundColor2 $writeEmptyLine
 
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
sleep -Seconds 30
## Create Landing Zones management groups
 
# Create Corp management group
New-AzManagementGroup -GroupName $corpManagementGroupName -DisplayName $corpManagementGroupName -ParentObject $landingZonesParentGroup | Out-Null
 
# Create Corp External management group
New-AzManagementGroup -GroupName $corpExternalManagementGroupName -DisplayName $corpExternalManagementGroupName -ParentObject $landingZonesParentGroup | Out-Null
 
# Create External management group
New-AzManagementGroup -GroupName $ExternalManagementGroupName -DisplayName $ExternalManagementGroupName -ParentObject $landingZonesParentGroup | Out-Null

# Create VDI management group
New-AzManagementGroup -GroupName $VDIManagementGroupName -DisplayName $VDIManagementGroupName -ParentObject $landingZonesParentGroup | Out-Null
 
Write-Host ($writeEmptyLine + "# Landing Zones management groups $corpManagementGroupName, $corpExternalManagementGroupName, VDIManagementGroupName and `
$ExternalManagementGroupName created" + $writeSeperatorSpaces + $currentTime) -foregroundcolor $foregroundColor2 $writeEmptyLine
 

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Write script completed
 
Write-Host ($writeEmptyLine + "# Script completed" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine
 
## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------