<# $date = Get-Date
$adaps = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration
$masterList = @()
$listofadapters = @()
$listofadapters += "$computerName Last checked $date"
$adapters = $adaps | Where-Object {$_.TcpipNetbiosOptions -eq "1" -or $_.TcpipNetbiosOptions -eq "0" -or $_.TcpipNetbiosOptions -eq "2"} #>
$adapters = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.TcpipNetbiosOptions -In 0..2 }

foreach ( $adapter in $adapters ) {
    $netbiosstatus = switch ( $adapter.TcpipNetbiosOptions ) {
        0 { "Enabled via DHCP" }
        1 { "Enabled" }
        2 { "Disabled" }
    }

    $adapter | Add-Member -MemberType NoteProperty -Name "NetBiosStatus" -Value $netbiosstatus

    <# if($adapter.TcpipNetbiosOptions -eq 0){$netbiosstatus = "Enabled via DHCP"}
    elseif($adapter.TcpipNetbiosOptions -eq 1){$netbiosstatus = "Enabled"}
    elseif($adapter.TcpipNetbiosOptions -eq 2){$netbiosstatus = "Disabled"}

    if ( $null -eq $adapter.SetTcpipNetbios(2) ) {
        $ret = New-Object PSObject
        $ret | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:COMPUTERNAME
        $ret | Add-Member -MemberType NoteProperty -Name "IPaddress" -Value ([string]::join(";",$adapter.IPAddress))
        $ret | Add-Member -MemberType NoteProperty -Name "MACAddress" -Value $adapter.MACAddress
        $ret | Add-Member -MemberType NoteProperty -Name "NetBiosStatus" -Value $netbiosstatus
        $ret | Add-Member -MemberType NoteProperty -Name "WINSEnableLMHostsLookup" -Value $adapter.WINSEnableLMHostsLookup
        $ret | Add-Member -MemberType NoteProperty -Name "WINSHostLookupFile" -Value $adapter.WINSHostLookupFile
        $masterList += $ret
    }
    else {
        $ret = New-Object PSObject
        $ret | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:COMPUTERNAME
        $ret | Add-Member -MemberType NoteProperty -Name "IPaddress" -Value ([string]::join(";",$adapter.IPAddress))
        $ret | Add-Member -MemberType NoteProperty -Name "MACAddress" -Value $adapter.MACAddress
        $ret | Add-Member -MemberType NoteProperty -Name "NetBiosStatus" -Value $netbiosstatus
        $ret | Add-Member -MemberType NoteProperty -Name "WINSEnableLMHostsLookup" -Value $adapter.WINSEnableLMHostsLookup
        $ret | Add-Member -MemberType NoteProperty -Name "WINSHostLookupFile" -Value $adapter.WINSHostLookupFile
        $masterList += $ret
    } #>
}

#$masterList

$properties = @(
    @{ N = 'ComputerName'; E = {$env:COMPUTERNAME} }
    @{ N = 'IPAddress'; E = {[string] $_.IPAddress.Split(",")[0]} }
    'MACAddress'
    'NetBiosStatus'
    'WINSEnableLMHostsLookup'
    'WINSHostLookupFile'
)

$adapters | Select-Object -Property $properties
