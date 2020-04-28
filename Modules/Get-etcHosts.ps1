$var = Get-Content C:\Windows\System32\drivers\etc\hosts
$finalObject = @()
$IPpattern = "([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}"
$hostnamepattern = "[A-Za-z-.0-9]+$"

$var | ForEach-Object {if($_ -notlike "#*" -and $_ -notlike $null -and $_ -notlike ""){
         $ret = New-Object PSObject
         $ret | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $env:COMPUTERNAME
         
         $ip = [regex]::Match($_, $IPpattern).captures.groups[0].value
          if($ip  -ne $null -and $ip -ne ""){
                $ret | Add-Member -MemberType NoteProperty -Name "etcHosts_IPaddress" -Value $ip      
          }
          $hostname = [regex]::Match($_, $hostnamepattern).captures.groups[0].value         
          if($hostname  -ne $null -and $hostname -ne ""){
                $ret | Add-Member -MemberType NoteProperty -Name "etcHosts_Hostname" -Value $hostname
          }
        $finalObject += $ret
        
  }
}

$finalObject
