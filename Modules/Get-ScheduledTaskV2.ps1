$path = "\\" + $env:COMPUTERNAME + "\c$\Windows\System32\Tasks"
$tasks = Get-ChildItem -recurse -Path $path -File
$masterList = @()
foreach ($task in $tasks)
{
       $TaskInfo = [xml](Get-Content ([string]::Concat($task.directory.fullname,"\",$task.Name)))        
       $obj = New-Object PSOBject -Property ([ordered]@{
           ComputerName = "$env:COMPUTERNAME"
           Task = $task.name
           User = $TaskInfo.task.principals.principal.userid
           Enabled = $TaskInfo.task.settings.enabled
           Application = $TaskInfo.task.actions.exec.command
           arg = $TaskInfo.task.actions.exec.Arguments
        })        
   $masterList += $obj
}

$masterList = $masterList | Where-Object {$_.arg -notlike ""  -and $_.user -notlike "" }  |  select-object task,user,enabled,application,arg
$masterList
