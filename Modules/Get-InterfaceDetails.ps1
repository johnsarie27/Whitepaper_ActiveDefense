            
        $Adapters = Get-NetAdapter  #get a list of network adapters
        $OutputArray = $null;
        $OutputArray = @();

        if ($Adapters) {
            $AdapterConfigs = Get-CimInstance Win32_NetworkAdapterConfiguration | Select-Object *  
            
            foreach ($Adapter in $Adapters) {
            if ($Adapter.MediaConnectionState -eq "Connected") {
                    $ret = New-Object PSObject
                    $AdapterConfig = $AdapterConfigs | Where {$_.InterfaceIndex -eq $Adapter.InterfaceIndex};

                    $ret | Add-Member -MemberType NoteProperty -Name "Computer" -Value $env:COMPUTERNAME
                    $ret | Add-Member -MemberType NoteProperty -Name "FQDN" -Value $Adapter.SystemName
                    $ret | Add-Member -MemberType NoteProperty -Name "Description" -Value $Adapter.InterfaceDescription
                    $ret | Add-Member -MemberType NoteProperty -Name "NetConnectionID"   -Value $Adapter.Name
                    $ret | Add-Member -MemberType NoteProperty -Name "NetConnected"  -Value $Adapter.MediaConnectionState
                    $ret | Add-Member -MemberType NoteProperty -Name "InterfaceIndex"  -Value $Adapter.ifIndex
                    $ret | Add-Member -MemberType NoteProperty -Name "Speed"  -Value $Adapter.Speed
                    $ret | Add-Member -MemberType NoteProperty -Name "MACAddress"  -Value $Adapter.MACAddress
                    $ret | Add-Member -MemberType NoteProperty -Name "IPAddress"  -Value $AdapterConfig.ipaddress[0]
                    $tempGW = $AdapterConfig.DefaultIPGateway | Select-Object
                    $ret | Add-Member -MemberType NoteProperty -Name "Gateway"  -Value $tempGW
                    
                    $tempcount = ($AdapterConfig.DNSServerSearchOrder).Count
                    
                    for($i=0; $i -lt 6; $i++ ){
                            $ret | Add-Member -MemberType NoteProperty -Name "DNS$i"  -Value $AdapterConfig.DNSServerSearchOrder[$i]
                    }
                    $ret | Add-Member -MemberType NoteProperty -Name "MTU"  -Value $Adapter.MtuSize
                    $ret | Add-Member -MemberType NoteProperty -Name "PromiscuousMode"  -Value $Adapter.PromiscuousMode
                    $OutputArray += $ret;
                };

            };

            Return $OutputArray;
            
        }
