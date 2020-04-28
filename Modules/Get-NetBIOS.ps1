$date = Get-DAte
$adaps=(gwmi win32_networkadapterconfiguration )
$masterList = @()
$listofadapters = @()
$listofadapters += "$computerName Last checked $date"
$adapters = $adaps | Where-Object {$_.TcpipNetbiosOptions -eq "1" -or $_.TcpipNetbiosOptions -eq "0" -or $_.TcpipNetbiosOptions -eq "2"} 
if($adapters.PSComputerName.count -gt 0){
    Foreach ($adapter in $adapters){
    if($adapter.TcpipNetbiosOptions -eq 0){$netbiosstatus = "Enabled via DHCP"}
    elseif($adapter.TcpipNetbiosOptions -eq 1){$netbiosstatus = "Enabled"}
    elseif($adapter.TcpipNetbiosOptions -eq 2){$netbiosstatus = "Disabled"}
        
    if($adapter.SetTcpipNetbios(2) -ne $null){
         $ret = New-Object PSObject
         $ret | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:COMPUTERNAME
         $ret | Add-Member -MemberType NoteProperty -Name "IPaddress" -Value ([string]::join(";",$adapter.IPAddress))
         $ret | Add-Member -MemberType NoteProperty -Name "MACAddress" -Value $adapter.MACAddress
         $ret | Add-Member -MemberType NoteProperty -Name "NetBiosStatus" -Value $netbiosstatus
         $ret | Add-Member -MemberType NoteProperty -Name "WINSEnableLMHostsLookup" -Value $adapter.WINSEnableLMHostsLookup
         $ret | Add-Member -MemberType NoteProperty -Name "WINSHostLookupFile" -Value $adapter.WINSHostLookupFile
         $masterList += $ret
        }    
    else{
         $ret = New-Object PSObject
         $ret | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:COMPUTERNAME
         $ret | Add-Member -MemberType NoteProperty -Name "IPaddress" -Value ([string]::join(";",$adapter.IPAddress))
         $ret | Add-Member -MemberType NoteProperty -Name "MACAddress" -Value $adapter.MACAddress
         $ret | Add-Member -MemberType NoteProperty -Name "NetBiosStatus" -Value $netbiosstatus
         $ret | Add-Member -MemberType NoteProperty -Name "WINSEnableLMHostsLookup" -Value $adapter.WINSEnableLMHostsLookup
         $ret | Add-Member -MemberType NoteProperty -Name "WINSHostLookupFile" -Value $adapter.WINSHostLookupFile
         $masterList += $ret
        }
    }
}

$masterList
