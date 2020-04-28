
$settings =  gc "\\lab-script-01\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
. $settings.loadFunctions

$outputFolder = [string]::Concat($settings.OutputFolder,"\",$env:COMPUTERNAME)
if(!(Test-Path $outputFolder)){
    New-Item -Path $outputFolder -ItemType Directory
}


$lastruntimeFile =  [string]::Concat($outputFolder,"\",$settings.LastRunTimeFileName)

if((!(Test-path $lastruntimeFile))){ 
    New-Item -Path $lastruntimeFile -ItemType file -Force
}
else{
    $lastWriteTime = gci $lastruntimeFile | Select-Object LastWriteTime
    $24hrsAgo = (Get-Date).AddHours(-24)
    if($lastWriteTime.lastwritetime -lt $24hrsAgo){
         New-Item -Path $lastruntimeFile -ItemType file -Force
    }
    else{ exit;  }
}

$processes = ($settings.ScriptsFolder +  "\Modules\Get-Processess.ps1")
$services  = ($settings.ScriptsFolder +  "\Modules\Get-Services.ps1")
$dnscache  = ($settings.ScriptsFolder +  "\Modules\get-DNSCache.ps1")
$tcpConn   = ($settings.ScriptsFolder +  "\Modules\Get-TCPConnections.ps1") 
$udpConn   = ($settings.ScriptsFolder +  "\Modules\Get-UDPConnections.ps1") 
$installedSoftware   = ($settings.ScriptsFolder +  "\Modules\Get-InstalledSoftwareByRegistry.ps1") 
$environmentPath = ($settings.ScriptsFolder + "\Modules\Get-EnvironmentalVariablePaths.ps1")
$mitreTechT1015_AccessibilityFeatures   = ($settings.ScriptsFolder +  "\Modules\Get-AccessibilityFeatures.ps1") 
$mitreTechT1015_AccessibilityFeatures2   = ($settings.ScriptsFolder +  "\Modules\Get-AccessibilityFeatures2.ps1") 
$mitreTechT1504_PowershellProfiles      = ($settings.ScriptsFolder +  "\Modules\Get-PowershellProfiles.ps1")  
$arpa      = ($settings.ScriptsFolder +  "\Modules\Get-arp-a.ps1")  
$etchosts      = ($settings.ScriptsFolder +  "\Modules\Get-etcHosts.ps1")  
$localgroupMembership  = ($settings.ScriptsFolder +  "\Modules\Get-LocalGroupMembership.ps1")  
$GetinstalledFeatures = ($settings.ScriptsFolder +  "\Modules\Get-installedFeatures.ps1")  
$netBios = ($settings.ScriptsFolder +  "\Modules\Get-NetBIOS.ps1")  
$firefoxExtensions = ($settings.ScriptsFolder +  "\Modules\Get-FireFoxExtensions_T1176.ps1")  
$chromexExtensions = ($settings.ScriptsFolder +  "\Modules\Get-ChromeExtensions_T1176.ps1")  
$LinuxSubsystems = ($settings.ScriptsFolder +  "\Modules\Get-LinuxSubsystems.ps1")  
$ProcessByOwner = ($settings.ScriptsFolder +  "\Modules\Get-UserProcesses.ps1")  
$ChocolateyPackages = ($settings.ScriptsFolder +  "\Modules\Get-ChocolateyPackages.ps1")  
$ComputerSummary = ($settings.ScriptsFolder +  "\Modules\Get-ComputerSummary.ps1")  
$InsecurePermissions = ($settings.ScriptsFolder +  "\Modules\Get-InsecurePermissions_V2.ps1")  
$RDPUSers = ($settings.ScriptsFolder +  "\Modules\Get-RDPUsers.ps1")  
$credentialGuardStatus = ($settings.ScriptsFolder +  "\Modules\Get-credentialGuardStatus.ps1")  
$SecuritySupportProvider_T1101 = ($settings.ScriptsFolder +  "\Modules\Get-SecuritySupportProvider_T1101.ps1")  
$GetScheduledTasks = ($settings.ScriptsFolder +  "\Modules\Get-ScheduledTasks.ps1")  
$mandatorySoftware = ($settings.ScriptsFolder +  "\Modules\Get-MandatorySoftwareStatus.ps1")  
$hotfixes = ($settings.ScriptsFolder + "\modules\get-hotfixes.ps1")

Create-Report -filename Processes -fileType $settings.OutputFileType `
         -scriptvariable $processes -outputFolder $outputFolder
Create-Report -filename Services  -fileType $settings.OutputFileType `
         -scriptvariable $services -outputFolder $outputFolder
Create-Report -filename dnsCache  -fileType $settings.OutputFileType `
         -scriptvariable $dnscache -outputFolder $outputFolder
Create-Report -filename tcpConnections -fileType $settings.OutputFileType `
         -scriptvariable $tcpConn  -outputFolder $outputFolder
Create-Report -filename udpConnections -fileType $settings.OutputFileType `
         -scriptvariable $udpConn  -outputFolder $outputFolder
Create-Report -filename installedSoftware -fileType $settings.OutputFileType `
         -scriptvariable $installedSoftware -outputFolder $outputFolder
Create-Report -filename envPath     -fileType $settings.OutputFileType `
         -scriptvariable $environmentPath   -outputFolder $outputFolder
Create-Report -filename AccessibilityFeatures_T1015  -fileType $settings.OutputFileType `
         -scriptvariable $mitreTechT1015_AccessibilityFeatures -outputFolder $outputFolder
Create-Report -filename PowerShellProfiles_T1504     -fileType $settings.OutputFileType `
         -scriptvariable $mitreTechT1504_PowershellProfiles   -outputFolder $outputFolder
Create-Report -filename ArpA        -fileType $settings.OutputFileType `
         -scriptvariable $arpa      -outputFolder $outputFolder
Create-Report -filename etcHosts    -fileType $settings.OutputFileType `
         -scriptvariable $etchosts   -outputFolder $outputFolder
Create-Report -filename LocalGroupMemberships        -fileType $settings.OutputFileType `
         -scriptvariable $localgroupMembership   -outputFolder $outputFolder
Create-Report -filename getinstalledfeatures         -fileType $settings.OutputFileType `
         -scriptvariable $GetinstalledFeatures   -outputFolder $outputFolder
Create-Report -filename NetBIOS                      -fileType $settings.OutputFileType `
         -scriptvariable $netBios   -outputFolder $outputFolder
Create-Report -filename FireFoxExtensions            -fileType $settings.OutputFileType `
         -scriptvariable $firefoxExtensions   -outputFolder $outputFolder
Create-Report -filename ChromeExtensions             -fileType $settings.OutputFileType `
         -scriptvariable $chromexExtensions   -outputFolder $outputFolder
Create-Report -filename LinuxSubsystems              -fileType $settings.OutputFileType `
         -scriptvariable $LinuxSubsystems   -outputFolder $outputFolder
Create-Report -filename ProcessByOwner               -fileType $settings.OutputFileType `
         -scriptvariable $ProcessByOwner   -outputFolder $outputFolder
Create-Report -filename ChocolateyPackages           -fileType $settings.OutputFileType `
         -scriptvariable $ChocolateyPackages   -outputFolder $outputFolder
Create-Report -filename ComputerSummary              -fileType $settings.OutputFileType ` 
        -scriptvariable $ComputerSummary   -outputFolder $outputFolder
Create-Report -filename InsecurePermissions2          -fileType $settings.OutputFileType `
         -scriptvariable $InsecurePermissions   -outputFolder $outputFolder
Create-Report -filename RDPUSers                     -fileType $settings.OutputFileType `
         -scriptvariable $RDPUSers   -outputFolder $outputFolder
Create-Report -filename credentialGuardStatus        -fileType $settings.OutputFileType `
         -scriptvariable $credentialGuardStatus   -outputFolder $outputFolder
Create-Report -filename SecuritySupportProvider_T1101 -fileType $settings.OutputFileType `
         -scriptvariable $SecuritySupportProvider_T1101   -outputFolder $outputFolder
Create-Report -filename mitreTechT1015_AccessibilityFeatures2 -fileType $settings.OutputFileType `
         -scriptvariable $mitreTechT1015_AccessibilityFeatures2   -outputFolder $outputFolder
Create-Report -filename GetScheduledTasks             -fileType $settings.OutputFileType `
         -scriptvariable $GetScheduledTasks   -outputFolder $outputFolder
Create-Report -filename insecurepermissions           -fileType $settings.OutputFileType `
         -scriptvariable $insecurepermissions   -outputFolder $outputFolder
Create-Report -filename mandatorySoftware             -fileType $settings.OutputFileType `
         -scriptvariable $mandatorySoftware   -outputFolder $outputFolder
Create-Report -filename hotfixes  -fileType $settings.OutputFileType     `
         -scriptvariable $hotfixes -outputFolder $outputFolder
 

 


foreach($pro in $mitreTechT1504_PowershellProfiles){
    $outputProfilesLocation = [string]::Concat($settings.OutputFolder,"\",$env:COMPUTERNAME,"\PowerShellProfiles")
    if(!(Test-Path $outputProfilesLocation)){ New-Item $outputProfilesLocation -Name "PowerShellProfiles" -ItemType Directory }
    if($pro.PowershellProfileListLocation -ne $null) {
        Copy-Item -Path $pro.PowershellProfileListLocation -Destination "$outputProfilesLocation\profile.txt" 
    }
}
