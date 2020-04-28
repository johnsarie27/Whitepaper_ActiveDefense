$arp = arp -a
$finalList = @()
FOREACH ($a in $arp)
{ 
    $a = $a -replace '^\s+', ''   
    $a = $a -split '\s+'
    if($a[0] -ne $null -and $a[1] -ne $null -and $a[2] -ne $null -and $a[0] -ne "Interface:" `
         -and $a[0] -ne  "Internet"          ){
        $object = New-Object -TypeName PSObject
        $object | Add-Member -Name 'ComputerName' -MemberType NoteProperty -Value $env:COMPUTERNAME
        $object | Add-Member -Name 'Address' -MemberType NoteProperty -Value $a[0]
        $object | Add-Member -Name 'MAC' -MemberType NoteProperty -Value $a[1]
        $object | Add-Member -Name 'Type' -MemberType NoteProperty -Value $a[2]
        $finalList += $object
    } 
}
$finalList
