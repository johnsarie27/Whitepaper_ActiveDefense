#https://adsecurity.org/?p=1760
$settings =  gc "\\lab-script-01\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
$scriptFolder = $settings.ScriptsFolder
$baselineSP = Import-Csv "$scriptFolder\GlobalSettings\SecurityPackages_T1101.csv"

$MasterList = @()
$securityPackages = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "Security Packages"

if($securityPackages.'Security Packages'.count -gt 0){
    foreach($sp in $securityPackages.'Security Packages'){
       if($baselineSP.AuthenticationSSP_Name -notcontains $sp -and $sp -notlike '""'){
            $obj = New-Object PSObject
            $obj | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:Computername
            $obj | Add-Member -MemberType NoteProperty -Name "Possible_persistenceAuth" -Value $sp
            $obj | Add-Member -MemberType NoteProperty -Name "ReferenceLink" -value "https://adsecurity.org/?p=1760"
            $MasterList += $obj
        }
    }
}

$MasterList
