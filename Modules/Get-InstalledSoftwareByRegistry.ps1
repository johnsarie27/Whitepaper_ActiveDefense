
$Software = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* `
 | Select-Object DisplayName,DisplayVersion,Publisher,InstallDate, UninstallString, InstallLocation 

$Software += Get-ItemProperty  HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* `
 | Select-Object DisplayName,DisplayVersion,Publisher,InstallDate, UninstallString, InstallLocation 

$Software = $Software | Where-Object {[string]::IsNullOrWhiteSpace($_.displayname) -eq $false} `
     | Select-Object @{name="ComputerName";expression={$env:COMPUTERNAME}}, * |  Sort-Object DisplayName

$Software
