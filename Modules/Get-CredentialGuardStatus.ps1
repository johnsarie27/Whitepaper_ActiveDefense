$DetailedLIst = @()
$DevGuard = Get-CimInstance -classname Win32_DeviceGuard -namespace root\Microsoft\Windows\DeviceGuard
$osversion = (Get-WmiObject Win32_OperatingSystem).Caption

foreach($l in $DevGuard){
    
    $ret = New-Object PSObject   
    $ret | Add-Member -MemberType NoteProperty -Name "Computer" -Value $env:COMPUTERNAME
    $ret | Add-Member -MemberType NoteProperty -Name "ComputerVersion" -Value $osversion
    if ($DevGuard.SecurityServicesConfigured -contains 0) {     $ret `
        | Add-Member -MemberType NoteProperty -Name "CredentialGuardConfigured" -Value "No services configured"   }
    elseif ($DevGuard.SecurityServicesConfigured -contains 1) { $ret `
        | Add-Member -MemberType NoteProperty -Name "CredentialGuardConfigured" -Value "Windows Defender Credential Guard is configured"    }
    elseif ($DevGuard.SecurityServicesConfigured -contains 2) { $ret | `
        Add-Member -MemberType NoteProperty -Name "CredentialGuardConfigured" -Value "HVCI is configured"    }
    elseif ($DevGuard.SecurityServicesConfigured -contains 3) { $ret | `
        Add-Member -MemberType NoteProperty -Name "CredentialGuardConfigured" -Value "System Guard Secure Launch is configured"    }
    if ($DevGuard.SecurityServicesRunning -contains 0) {        $ret | ` 
        Add-Member -MemberType NoteProperty -Name "CredentialGuardRunning" -Value "No services running"    }
    elseif ($DevGuard.SecurityServicesRunning -contains 1) {    $ret | ` 
        Add-Member -MemberType NoteProperty -Name "CredentialGuardRunning" -Value "Windows Defender Credential Guard is running"    }
    elseif ($DevGuard.SecurityServicesRunning -contains 2) {    $ret | ` 
        Add-Member -MemberType NoteProperty -Name "CredentialGuardRunning" -Value "HVCI is running"    }
    elseif ($DevGuard.SecurityServicesRunning -contains 3) {    $ret | ` 
        Add-Member -MemberType NoteProperty -Name "CredentialGuardRunning" -Value "System Guard Secure Launch is running."    }
    if ($DevGuard.VirtualizationBasedSecurityStatus -contains 0) {     `   
        $ret | Add-Member -MemberType NoteProperty -Name "VBS Status" -Value "VBS is not enabled"    }
    elseif ($DevGuard.VirtualizationBasedSecurityStatus -contains 1) { `   
        $ret | Add-Member -MemberType NoteProperty -Name "VBS Status" -Value "VBS is enabled but not running"    }
    elseif ($DevGuard.VirtualizationBasedSecurityStatus -contains 2) { `   
        $ret | Add-Member -MemberType NoteProperty -Name "VBS Status" -Value "VBS is enabled and running"    }
    $DetailedLIst += $ret
}


$detailedList
