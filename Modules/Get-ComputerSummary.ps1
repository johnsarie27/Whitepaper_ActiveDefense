$userFolders = Get-ChildItem C:\Users

# From http://ilovepowershell.com/2015/09/10/how-to-check-if-a-server-needs-a-reboot/
$pendingReboot = $false
$pendingRebootReasons = @()
if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA SilentlyContinue) { 
    $pendingReboot = $true
    $pendingRebootReasons += "ComponentBasedServicing" 
}
if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA SilentlyContinue) { 
    $pendingReboot = $true 
    $pendingRebootReasons += "WindowsUpdate" 
}
if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -EA SilentlyContinue) { 
    $pendingReboot = $true
    $pendingRebootReasons += "PendingFileRenameOperations" 
}

try { 
    $util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
    $status = $util.DetermineIfRebootPending()
    if(($status -ne $null) -and $status.RebootPending) {
        $pendingReboot = $true
        $pendingRebootReasons += "SCCM" 
    }
} catch {}

#get bitlocker volume status
$btl = @()
try { 
    $btl += Get-BitlockerVolume
} catch {}

$ret = New-Object PSObject

$ret | Add-Member -MemberType NoteProperty -Name ComputerName -Value $env:COMPUTERNAME
$ret | Add-Member -MemberType NoteProperty -Name ProductName -Value (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
$ret | Add-Member -MemberType NoteProperty -Name EditionID -Value (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name EditionID).EditionID
$ret | Add-Member -MemberType NoteProperty -Name UserFolders -Value ($userFolders | Sort-Object LastAccessTime -Descending)
$ret | Add-Member -MemberType NoteProperty -Name NetIPAddresses -Value (Get-NetIPAddress)
$ret | Add-Member -MemberType NoteProperty -Name Win32NetworkAdapterConfiguration -Value (Get-WmiObject Win32_NetworkAdapterConfiguration | Where { $_.IPAddress } )
$ret | Add-Member -MemberType NoteProperty -Name Win32OperatingSystem -Value (Get-WmiObject win32_operatingsystem)
$ret | Add-Member -MemberType NoteProperty -Name Win32ComputerSystem -Value (Get-WmiObject win32_computersystem)
$ret | Add-Member -MemberType NoteProperty -Name Win32Processors -Value  (Get-WmiObject win32_processor | select deviceid,loadpercentage,architecture,description,name,numberofcores,NumberOfLogicalProcessors  )
$ret | Add-Member -MemberType NoteProperty -Name Win32Volumes -Value (Get-WmiObject win32_volume | select Caption,driveletter,drivetype,freespace,capacity,name,label,filesystem) 
if((Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient') -eq $false){$multicast = $false}
else{$multicast = (Get-Item 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient').GetValue("EnableMulticast")}
$ret | Add-Member -MemberType NoteProperty -Name DNSClientEnableMulticast -Value $multicast
$ret | Add-Member -MemberType NoteProperty -Name PendingReboot -Value $pendingReboot
$ret | Add-Member -MemberType NoteProperty -Name PendingRebootReasons -Value ($pendingRebootReasons -join ",")
$ret | Add-Member -MemberType NoteProperty -Name BitlockerVolumeStatus -Value $btl

$ret
