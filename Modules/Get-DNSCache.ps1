$dnsclientCache = Get-DnsClientCache | Select-Object @{name="ComputerName";expression={$env:COMPUTERNAME}}, *
$dnsclientCache
