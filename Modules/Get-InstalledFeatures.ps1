$windowsversion = Get-ComputerInfo | Select-Object  WindowsProductName, WindowsCurrentVersion,WindowsEditionId,WindowsInstallationType
$list = @()
if($windowsversion -notlike "*windows 10*"){
    $List = Get-WindowsFeature  | where {$_.installed} `
           | Select @{Name="ComputerName";Expression={$env:COMPUTERNAME}},DisplayName,Name, Installed | Sort-Object DisplayName
}
elseif($windowsversion -like "*windows 10*"){
    $templist = Get-WindowsOptionalFeature -online | Where-Object {$_.state -eq "Enabled"} 
    foreach($i in $templist){ 
        $list += Get-WindowsOptionalFeature -online -featureName $i.FeatureName
    }
    $list = $list | ` 
         Select @{Name="ComputerName";Expression={$env:COMPUTERNAME}},DisplayName,FeatureName, @{name="Installed";expression={$true}} `
        | Sort-Object DisplayName
}
$List
