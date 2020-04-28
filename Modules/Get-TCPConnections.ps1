$tcpConn = Get-NetTCPConnection | Select @{name="ComputerName";expression={$env:COMPUTERNAME}},* | Sort-Object LocalPort 
$tcpConn
