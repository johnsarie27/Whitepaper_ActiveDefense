$services = Get-Service | Select-Object -Property  @{name="ComputerName";expression={"$env:COMPUTERNAME"}},status,Name,DisplayName,StartType

$services
