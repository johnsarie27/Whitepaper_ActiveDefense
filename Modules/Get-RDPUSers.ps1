$rdpUsers = net localgroup "Remote Desktop Users" | where {$_ -AND $_ -notmatch "command completed successfully"}  | select -skip 4 | Select-Object @{name="ComputerName";expression={$env:COMPUTERNAME}}, @{name="UserName";expression={$_}}
$rdpUsers 
