$shareServer = "lab-script-01"
$settings =  Get-Content "\\$shareServer\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json

. $settings.loadFunctions

. Send-InsecureServicePermissions -Action ReturnData
