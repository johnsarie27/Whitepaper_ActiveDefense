$settings =  get-content "\\lab-script-01\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
$listofInstalledSoftware = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* `
    | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate, URLInfoAbout, UninstallString, InstallLocation 
$listofInstalledSoftware += Get-ItemProperty  HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* `
    | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate, URLInfoAbout, UninstallString, InstallLocation 
$listofInstalledSoftware = $listofInstalledSoftware | Where-Object {$_.displayname -ne "" -and $_.displayname -ne $null} `
     | Select-Object @{name="ComputerName";expression={$env:COMPUTERNAME}}, * |  Sort-Object DisplayName

$listofServices = Get-service
$masterList = @()
foreach($mandatorysoftware in $settings.SecuritySoftware){
        $ret = New-Object PSObject
        $ret | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:COMPUTERNAME
        $ret | Add-Member -MemberType NoteProperty -Name "Mandatory Software" -Value $mandatorysoftware.Application
        if(($listofInstalledSoftware).displayname -contains $mandatorysoftware.registrykeyword ){
          $ret | Add-Member -MemberType NoteProperty -Name "Installed" -Value $true
        }
        else{$ret | Add-Member -MemberType NoteProperty -Name "Installed" -Value $false}

        if(($listofServices | Select-Object name).Name -contains $mandatorysoftware.servicename ){
          $ret | Add-Member -MemberType NoteProperty -Name "Service_Running" -Value $true
        }
        else{$ret | Add-Member -MemberType NoteProperty -Name "Service_Running" -Value $false}
        $masterList += $ret
}
$masterList
