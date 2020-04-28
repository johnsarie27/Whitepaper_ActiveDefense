$processes = Get-Process -IncludeUserName |  Select-Object  @{name="ComputerName";expression={"$env:COMPUTERNAME"}} `
        ,ProcessName,UserName,PriorityClass,Id,HandleCount,@{name="WorkingSet_MB";expression={$_.workingSet/1MB}},Path

$processes
