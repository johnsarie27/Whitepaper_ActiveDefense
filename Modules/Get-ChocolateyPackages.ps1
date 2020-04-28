$DetailedLIst = @()

if(Test-Path -Path C:\ProgramData\chocolatey){
    $installedpackages = choco list --local-only
    if($installedpackages.Count -gt 0){
        foreach ($i in $installedpackages){
            if($i -notlike "*packages installed*"){
                  $ret = New-Object PSObject
                    $ret | Add-Member -MemberType NoteProperty -Name "Computer" -Value $env:COMPUTERNAME
                    $version = $i -split " "
                    $ret | Add-Member -MemberType NoteProperty -Name "Package" -Value $version[0]
                    $ret | Add-Member -MemberType NoteProperty -Name "Version" -Value $version[-1]
                    $DetailedLIst += $ret
            }
        }
    }
}
$DetailedLIst
