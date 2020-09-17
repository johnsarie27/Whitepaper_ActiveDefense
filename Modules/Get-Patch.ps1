
<# $data = @()
$hotfixes = Get-HotFix | Select-Object CSname,Description,HotFixID,InstalledOn,InstalledBy,Caption `
     | Sort-Object InstalledOn -Descending

$hotfixes | ForEach-Object {
    $ret = New-Object PSObject
    $ret | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:COMPUTERNAME
    $ret | Add-Member -MemberType NoteProperty -Name "Description" -Value $_.Description
    $ret | Add-Member -MemberType NoteProperty -Name "Caption" -Value $_.caption
    $ret | Add-Member -MemberType NoteProperty -Name "Hotfix_ID" -Value $_.hotfixid
    $ret | Add-Member -MemberType NoteProperty -Name "InstalledOn" -Value $_.InstalledOn
    $ret | Add-Member -MemberType NoteProperty -Name "InstalledBy" -Value $_.InstalledBy
    $data += $ret
}
$data #>


$properties = @('PSComputerName', 'Description', 'Caption', 'HotFixID', 'InstalledOn', 'InstalledBy')

Get-HotFix | Select-Object -Property $properties
