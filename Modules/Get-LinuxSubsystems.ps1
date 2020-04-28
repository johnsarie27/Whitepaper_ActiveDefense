##Gets users that are using the Linux subsystem (includes Kali,Ubuntu,Debian, openSUSE)

$var = gci "C:\Users\*\AppData\Local\Packages\*" | Select-Object Fullname, name, `
     @{name="user";expression={($_.FullName -split '\\')[2]}}  `
        | Where-Object {$_.name -like "*Canonical*" -or $_.name -like "*KaliLinux*" -or $_.name `
        -like "*openSUSE*" -or $_.name -like "*Alpine*" -or $_.name -like "*Debian*" }

$detailedList = @()
foreach($l in $var){
        $ret = New-Object PSObject
        $ret | Add-Member -MemberType NoteProperty -Name "Computer" -Value $env:COMPUTERNAME
        $ret | Add-Member -MemberType NoteProperty -Name "User" -Value $l.user
        $ret | Add-Member -MemberType NoteProperty -Name "Name" -Value $l.Name
        $ret | Add-Member -MemberType NoteProperty -Name "path" -Value $l.Fullname
        $DetailedLIst += $ret
}
$detailedList
