$arrInterfaces = (Get-WmiObject -class Win32_NetworkAdapterConfiguration -filter "ipenabled = TRUE") 

$OutputArray = @()
 foreach ($Adapter in $arrInterfaces) {#loop through the Interfaces and build the outputArray         
                    $ret = New-Object PSObject
                    $ret | Add-Member -MemberType NoteProperty -Name "Computer" -Value $env:Computername
                    $ret | Add-Member -MemberType NoteProperty -Name "DNSdomain" -Value $Adapter.DNSdomain
                    $ret | Add-Member -MemberType NoteProperty -Name "Description" -Value $Adapter.Description
                    
                    
                    for($i=0; $i -lt 3; $i++ ){
                            $ret | Add-Member -MemberType NoteProperty -Name "IP$i"  -Value $Adapter.IPaddress[$i]
                    }
                    for($i=0; $i -lt 1; $i++ ){
                            $ret | Add-Member -MemberType NoteProperty -Name "Gateway$i"  -Value $Adapter.DEfaultIPgateway[$i]
                    }

                    $OutputArray += $ret;
                };
 $OutputArray
