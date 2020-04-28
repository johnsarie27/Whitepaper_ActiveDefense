$data = @()
$firefoxExtensions = Get-ChildItem "C:\users\*\AppData\Roaming\Mozilla\Firefox\Profiles" -recurse -Filter addons.json

$firefoxExtensions |  ForEach-Object {
    $details = (Get-Content $_.FullName | ConvertFrom-Json).addons
    $temp = ($_.FullName -split "\\");  
    foreach($ext in $details){ 
        $ret = New-Object PSObject
        $ret | Add-Member -MemberType NoteProperty -Name ComputerName -Value $env:COMPUTERNAME
        $ret | Add-Member -MemberType NoteProperty -Name User -Value $temp[2]
        $ret | Add-Member -MemberType NoteProperty -Name Name -Value $ext.Name
        $ret | Add-Member -MemberType NoteProperty -Name Creator -Value $ext.creator.Name
        $ret | Add-Member -MemberType NoteProperty -Name Version -Value $ext.version
        $ret | Add-Member -MemberType NoteProperty -Name sourceURI -Value $ext.sourceuri
        $ret | Add-Member -MemberType NoteProperty -Name InstallPath -Value $_.FullName
        $data += $ret
    }
}
$data
