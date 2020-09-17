
$settings =  Get-Content "\\lab-script-01\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
. $settings.loadFunctions

$outputFolder = Join-Path -Path $settings.OutputFolder -ChildPath $env:COMPUTERNAME
if ( !(Test-Path $outputFolder) ) {
    New-Item -Path $outputFolder -ItemType Directory
}

$lastruntimeFile = Join-Path -Path $outputFolder -ChildPath $settings.LastRunTimeFileName

if ( !(Test-path $lastruntimeFile) ) {
    New-Item -Path $lastruntimeFile -ItemType file -Force
}
else {
    $lastWriteTime = Get-ChildItem $lastruntimeFile | Select-Object LastWriteTime

    if ( $lastWriteTime.lastwritetime -lt (Get-Date).AddHours(-24) ) {
         New-Item -Path $lastruntimeFile -ItemType file -Force
    }
    else {
        exit
    }
}

$vars = @{
    processes                             = "Get-Processess"
    services                              = "Get-Services"
    dnscache                              = "get-DNSCache"
    tcpConn                               = "Get-TCPConnections"
    udpConn                               = "Get-UDPConnections"
    installedSoftware                     = "Get-InstalledSoftwareByRegistry"
    environmentPath                       = "Get-EnvironmentalVariablePaths"
    mitreTechT1015_AccessibilityFeatures  = "Get-AccessibilityFeatures"
    mitreTechT1015_AccessibilityFeatures2 = "Get-AccessibilityFeatures2"
    mitreTechT1504_PowershellProfiles     = "Get-PowershellProfiles"
    arpa                                  = "Get-arp-a"
    etchosts                              = "Get-etcHosts"
    localgroupMembership                  = "Get-LocalGroupMembership"
    GetinstalledFeatures                  = "Get-installedFeatures"
    netBios                               = "Get-NetBIOS"
    firefoxExtensions                     = "Get-FireFoxExtensions_T1176"
    chromexExtensions                     = "Get-ChromeExtensions_T1176"
    LinuxSubsystems                       = "Get-LinuxSubsystems"
    ProcessByOwner                        = "Get-UserProcesses"
    ChocolateyPackages                    = "Get-ChocolateyPackages"
    ComputerSummary                       = "Get-ComputerSummary"
    InsecurePermissions                   = "Get-InsecurePermissions_V2"
    RDPUSers                              = "Get-RDPUsers"
    credentialGuardStatus                 = "Get-credentialGuardStatus"
    SecuritySupportProvider_T1101         = "Get-SecuritySupportProvider_T1101"
    GetScheduledTasks                     = "Get-ScheduledTasks"
    mandatorySoftware                     = "Get-MandatorySoftwareStatus"
    hotfixes                              = "Get-Patch"
}

$reportParams = @{ FileType = $settings.OutputFileType; OutputFolder = $outputFolder }

foreach ( $v in $vars.GetEnumerator() ) {
    $value = Join-Path -Path $settings.ScriptsFolder -ChildPath ("Modules\{0}.ps1" -f $v.Value)
    #New-Variable -Name $v.Key -Value $value

    New-Report -FileName $v.Key -ScriptVariable $value @reportParams
}



foreach ( $pro in $mitreTechT1504_PowershellProfiles ) {

    $outputProfilesLocation = Join-Path -Path $settings.OutputFolder -ChildPath "$env:COMPUTERNAME\PowerShellProfiles"

    if ( !(Test-Path $outputProfilesLocation) ) {
        New-Item $outputProfilesLocation -Name "PowerShellProfiles" -ItemType Directory
    }
    if ( $null -ne $pro.PowershellProfileListLocation )  {
        Copy-Item -Path $pro.PowershellProfileListLocation -Destination "$outputProfilesLocation\profile.txt"
    }
}
