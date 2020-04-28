$udpConn = Get-NetUDPEndpoint  | Select-Object @{name="ComputerName";expression={$env:COMPUTERNAME}},* | Sort-Object LocalPort 
$udpConn
