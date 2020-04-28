$fullList = @()
$versionRegex = "C:\\Users\\.+\\AppData\\Local\\Google\\Chrome\\User Data\\Default\\Extensions\\\w+\\(.+?)\\"

$extensions = get-childitem "C:\Users\*\AppData\Local\Google\Chrome\User Data\Default\Extensions\*" 
foreach($folder in $extensions){
    $ret = New-Object -TypeName PSObject
    $temppath  = Get-ChildItem $folder.FullName -Recurse -Filter manifest.json
    $manifest = Get-Content $temppath.FullName | ConvertFrom-Json
    if($manifest.container -notlike "_MSG_" -and $manifest.container -ne "" -and $manifest.container -ne $null){
        $ret | Add-Member -MemberType NoteProperty -Name ComputerName -Value $env:COMPUTERNAME
        $ret | Add-Member -MemberType NoteProperty -Name ExtensionName -Value $manifest.container
        $ret | Add-Member -MemberType NoteProperty -Name AppId -Value $folder.Name       
        $ret | Add-Member -MemberType NoteProperty -Name Version -Value $manifest.Version
        $ret | Add-Member -MemberType NoteProperty -Name FilePath -Value $temppath.FullName
        $fullList += $ret
    }
    elseif($manifest.name -ne "" -and $manifest.name -ne $null -and $manifest.name -notlike "*_MSG_*"){
        $ret | Add-Member -MemberType NoteProperty -Name ComputerName -Value $env:COMPUTERNAME
        $ret | Add-Member -MemberType NoteProperty -Name ExtensionName -Value $manifest.name
        $ret | Add-Member -MemberType NoteProperty -Name AppId -Value $folder.Name       
        $ret | Add-Member -MemberType NoteProperty -Name Version -Value $manifest.Version
        $ret | Add-Member -MemberType NoteProperty -Name FilePath -Value $temppath.FullName
        $fullList += $ret
    }
    else{
       $temppath  = Get-ChildItem $folder.FullName -Recurse -Filter messages.json
       $tempPath = $temppath | Where-Object {$_.FullName -like "*\en\messages.json" -or  $_.FullName -like "*\en_US\messages.json"}

        $messages = Get-Content $temppath.FullName | ConvertFrom-Json
        if($messages.appName -or $messages.app_name){
            if($messages.appname){
                $ret | Add-Member -MemberType NoteProperty -Name ComputerName -Value $env:COMPUTERNAME
                $ret | Add-Member -MemberType NoteProperty -Name ExtensionName -Value $messages.appName.message
                $ret | Add-Member -MemberType NoteProperty -Name AppId -Value $folder.Name       
                $version = [regex]::Match($temppath.FullName, $versionRegex).captures.groups[1].value
                $ret | Add-Member -MemberType NoteProperty -Name Version -Value $version
                $ret | Add-Member -MemberType NoteProperty -Name FilePath -Value $temppath.FullName
            }
            elseif($messages.app_name){
                $ret | Add-Member -MemberType NoteProperty -Name ComputerName -Value $env:COMPUTERNAME
                $ret | Add-Member -MemberType NoteProperty -Name ExtensionName -Value $messages.app_Name.message
                $ret | Add-Member -MemberType NoteProperty -Name AppId -Value $folder.Name    
                $version = [regex]::Match($temppath.FullName, $versionRegex).captures.groups[1].value
                $ret | Add-Member -MemberType NoteProperty -Name Version -Value $version
                $ret | Add-Member -MemberType NoteProperty -Name FilePath -Value $temppath.FullName
            }
            $fullList += $ret                   
        }
    }
}
$fullList
