function Get-ADTrustRelationShips{

    $dclist = Get-ADGroupMember "Domain Controllers"
    $dclist += Get-ADGroupMember "Read-only Domain Controllers"
    $outputlist = @()
    $computername = hostname
    $dclist = $dclist | Select-object name |  sort-object

    foreach ($dc in $dclist.name){
       $object = New-Object -TypeName PSObject
       try{

            $res = Test-ComputerSecureChannel -server $dc
            $object | Add-Member -Name 'ComputerName' -MemberType NoteProperty -Value $computername
            $object | Add-Member -Name 'Hostname' -MemberType NoteProperty -Value $dc
            $object | Add-Member -Name 'status' -MemberType NoteProperty -Value $res
            $outputlist += $object

       }
       catch{
            $res = $false
            $object | Add-Member -Name 'ComputerName' -MemberType NoteProperty -Value $computername
            $object | Add-Member -Name 'Hostname' -MemberType NoteProperty -Value $dc
            $object | Add-Member -Name 'status' -MemberType NoteProperty -Value $res
            $outputlist += $object

       }
       
    }
    $outputlist
}

$output = Get-ADTrustRelationShips
$output
