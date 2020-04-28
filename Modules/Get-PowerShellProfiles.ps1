
#based off https://attack.mitre.org/techniques/T1504/
$listofUserPRofiles = ls C:\users\*
$listofPowerShellProfilePaths = @()
$masterOutputList =@()

if(Test-Path "$PsHome\Profile.ps1"){ $listofPowerShellProfilePaths += "$PsHome\Profile.ps1"}
elseif(Test-Path "$PsHome\Microsoft.Powershell_profile.ps1" ){ $listofPowerShellProfilePaths += "$PsHome\Microsoft.Powershell_profile.ps1"}
elseif(Test-Path "$PsHome\Microsoft.Powershell_ISE_profile.ps1"){ $listofPowerShellProfilePaths += "$PsHome\Microsoft.Powershell_ISE_profile.ps1"}

foreach($user in $listofUserPRofiles){
    $temp = [string]::Concat("C:\users\",$user.name,"\My Documents\PowerShell\Profile.ps1")
    $temp1 = [string]::Concat("C:\users\",$user.name,"\My Documents\PowerShell\Microsoft.Powershell_profile.ps1")
    $temp2 = [string]::Concat("C:\users\",$user.name,"\My Documents\PowerShell\Microsoft.Powershell_ISE_profile.ps1")
    if(Test-Path $temp){  $listofPowerShellProfilePaths += $temp  }
    if(Test-Path $temp1){ $listofPowerShellProfilePaths += $temp  }
    if(Test-Path $temp2){ $listofPowerShellProfilePaths += $temp  } 
}


foreach($existingPSPath in $listofPowerShellProfilePaths){
     $obj = New-Object -TypeName psobject
     $obj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $env:COMPUTERNAME
     $obj | Add-Member -MemberType NoteProperty -Name PowershellProfileListLocation -Value $existingPSPath
     $masterOutputList += $obj
}

foreach($PSP in $masterOutputList){
    if(!(Test-Path $temp)){  New-Item -Path "\\vsans-script-01\ComputerResults\$env:COMPUTERNAME\PowerShellProfiles" -ItemType Directory}

    $copyPath = $psp.PowershellProfileListLocation
    $tempFileName = $psp.PowershellProfileListLocation -replace ":","_" -replace "\\","_" -replace ".ps1",".txt"
    $destPath = ([string]::Concat("\\vsans-script-01\ComputerResults\$env:COMPUTERNAME","\","PowershellProfiles\", $tempFileName)) 
    Copy-Item $copyPath -Destination $destPath
}


$masterOutputList
