<#
.SYNOPSIS
Shows groups a user is member of.
.DESCRIPTION
This is a PowerShell script to get the groups a user is memeber of.
.PARAMETER UserName
The name of the User you want to run the command against.
.EXAMPLE
GetMemberOf UserName
#>

param(
[Parameter(Position=0,Mandatory=$True,HelpMessage="Name of the User")][String]$UserName,
[Parameter(HelpMessage="Output full recursive membership")][Switch]$Recurse
)

Add-Type -AssemblyName System.DirectoryServices.AccountManagement

$UserName = "DTS\$UserName"

$CTX = [System.DirectoryServices.AccountManagement.ContextType]::Domain
$UO = [System.DirectoryServices.AccountManagement.Principal]::FindByIdentity($CTX,$UserName)

If($UO -ne $Null){

 $Groups = $UO.GetGroups()

 If($Recurse){
  $Groups = $Groups + $UO.GetAuthorizationGroups() | Select-Object -Unique
 }

 Write-Host ""
 Write-Host "$($UO.DisplayName) is member of the following $(@($Groups).Count) AD groups:"
 Write-Host ""

 $Groups | Where-Object {$_.Guid -ne $Null} | Select-Object Name | Sort-Object Name | ForEach-Object {Write-Host "$($_.Name);"}

 Write-Host ""
}Else{
 Write-Host "User ""$UserName"" Not found"
}