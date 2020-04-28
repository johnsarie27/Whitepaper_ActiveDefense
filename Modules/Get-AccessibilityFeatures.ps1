
$possibleStickyKey = @()
$AccessibilityFeaturesFileHashes = @()
$cmdFileHash = @()

$AccessibilityFeaturesFileHashes += Get-FileHash -Algorithm SHA256 "C:\Windows\System32\sethc.exe"
$AccessibilityFeaturesFileHashes += Get-FileHash -Algorithm SHA256 "C:\Windows\System32\utilman.exe"
$AccessibilityFeaturesFileHashes += Get-FileHash -Algorithm SHA256 "C:\Windows\System32\osk.exe"
$AccessibilityFeaturesFileHashes += Get-FileHash -Algorithm SHA256 "C:\Windows\System32\Magnify.exe"
$AccessibilityFeaturesFileHashes += Get-FileHash -Algorithm SHA256 "C:\Windows\System32\Narrator.exe"
$AccessibilityFeaturesFileHashes += Get-FileHash -Algorithm SHA256 "C:\Windows\System32\DisplaySwitch.exe"
$AccessibilityFeaturesFileHashes += Get-FileHash -Algorithm SHA256 "C:\Windows\System32\AtBroker.exe"
$importedCMDFileHashes = Import-Csv -Path ($settings.CmdFileHashLocation +  $settings.CmdFileHashFileName)

foreach($hash in $AccessibilityFeaturesFileHashes){
    if($importedCMDFileHashes.hash -contains $hash.hash){
        $obj = New-Object -TypeName psobject
        $obj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $env:COMPUTERNAME
        $obj | Add-Member -MemberType NoteProperty -Name AccessHash -Value $hash.hash
        $obj | Add-Member -MemberType NoteProperty -Name Path -Value $hash.Path
        $getCMDosversion = $importedCMDFileHashes| Where-Object {$_.hash -eq $hash.Hash} `
                | Select-Object OperatingSystem, path,hash
        $obj | Add-Member -MemberType NoteProperty -Name CMD_os_version -Value $getCMDosversion.OperatingSystem
        $obj | Add-Member -MemberType NoteProperty -Name cmdpath -Value $getCMDosversion.path
        $obj | Add-Member -MemberType NoteProperty -Name cmdhash -Value $getCMDosversion.hash
        $possibleStickyKey += $obj
    }
}
