$var = Get-ChildItem env:Path
$list = $var | Select-Object Value, PSDrive,Name
$list = $list.Value -split ";" 
$masterList = @()
foreach($l in $list){
        if($l -ne $null -and $l -ne ""){    
            $obj = New-Object -TypeName psobject
            $obj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $env:COMPUTERNAME
            $obj | Add-Member -MemberType NoteProperty -Name EnvironmentalVariable -Value $l
            $masterList += $obj
        }
}
$masterList
