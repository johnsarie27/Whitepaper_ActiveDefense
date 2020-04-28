$processes = Get-CimInstance win32_process 

$list = @()
foreach($process in $processes){
   $var =  Invoke-CimMethod -InputObject $process -MethodName GetOwner 
   $createdObject = New-Object -TypeName psobject 
   $createdObject | Add-Member -MemberType NoteProperty -Name ComputerName -Value $env:computername
   $createdObject | Add-Member -MemberType NoteProperty -Name Name  -Value $process.Name
   $createdObject | Add-Member -MemberType NoteProperty -Name Owner -Value $var.User
   $createdObject | Add-Member -MemberType NoteProperty -Name ProcessId  -Value $process.ProcessId
   $createdObject | Add-Member -MemberType NoteProperty -Name ParentProcessId  -Value $process.ParentProcessId
   $createdObject | Add-Member -MemberType NoteProperty -Name Path  -Value $process.Path
   $list += $createdObject
}

$list
