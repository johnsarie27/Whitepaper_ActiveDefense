$obj = New-Object -TypeName psobject
$obj | Add-Member -MemberType NoteProperty -Name OutputFileType -Value 'csv'
$obj | Add-Member -MemberType NoteProperty -Name VerboseLogging -Value 'True'
$obj | Add-Member -MemberType NoteProperty -Name WaitingTime -Value '15'
$obj | Add-Member -MemberType NoteProperty -Name LoggingFileName -Value 'logging.log'
$obj | Add-Member -MemberType NoteProperty -Name LastRunTimeFileName -Value '.LastRunTime'
$obj | Add-Member -MemberType NoteProperty -Name OutputFolder -Value '\\vlab-dc-01\ComputerResults'

$temp = $obj
$temp | ConvertTo-Json | out-file S:\Scripts\alpha\settings.json 