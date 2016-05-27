  param(
    [Parameter()]
    [string]$Channel = $null,

    [Parameter()]
    [string]$Bitness = "32",

    [Parameter()]
    [string]$SourceFileFolder = "SourceFiles"
  )

#  Deploy Office 365 ProPlus using ConfigMgr

Process {
 $targetFilePath = "$env:temp\configuration.xml"
 $scriptPath = GetScriptRoot
 . "$scriptPath\SharedFunctions.ps1"
 if (Get-OfficeC2RVersion) { Write-Host "Office 365 ProPlus Already Installed" }

 ImportDeploymentDependencies -ScriptPath $scriptPath

 $UpdateURLPath = Locate-UpdateSource -Channel $Channel -UpdateURLPath $scriptPath -SourceFileFolder $SourceFileFolder
 Generate-ODTConfigurationXml -Languages AllInUseLanguages -TargetFilePath $targetFilePath | Set-ODTAdd -Version $NULL | Set-ODTDisplay -Level None -AcceptEULA $true  | Out-Null
 Update-ConfigurationXml -TargetFilePath $targetFilePath -UpdateURLPath $UpdateURLPath
 $languages = Get-XMLLanguages -Path $TargetFilePath

 #------------------------------------------------------------------------------------------------------------
 #   Customize Deployment Script - Uncomment and modify the code below to customize this deployment script
 #------------------------------------------------------------------------------------------------------------

  # Exclude-Applications -TargetFilePath $targetFilePath -ExcludeApps @("Access","Excel","Groove","InfoPath","Lync","OneDrive","OneNote","Outlook","PowerPoint","Project","Publisher","SharePointDesigner","Visio","Word")
 
  # Add-ProductSku -TargetFilePath $targetFilePath -Languages $languages -ProductIDs O365ProPlusRetail,O365BusinessRetail,VisioProRetail,ProjectProRetail

  # Remove-ProductSku -TargetFilePath $targetFilePath -Languages $languages -ProductIDs O365ProPlusRetail,O365BusinessRetail,VisioProRetail,ProjectProRetail

  


 
 #------------------------------------------------------------------------------------------------------------

 # Installs Office 365 ProPlus
 #Install-OfficeClickToRun -TargetFilePath $targetFilePath
 
 # Configuration.xml file for Click-to-Run for Office 365 products reference. https://technet.microsoft.com/en-us/library/JJ219426.aspx
}