function Send-InstalledSubsystems {
    [cmdletbinding()]
    Param(
        [parameter(ValueFromPipeline)]
        [ValidateSet('SendEmail','ReturnData')]
        [string[]] $Action
    )

    $settings =  gc "\\lab-script-01\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
    $outputfileName = "LinuxSubsystems"
    $buildOutputPaths =  Get-ChildItem ([string]::Concat($settings.OutputFolder,"\*\",$outputfileName, ".",$settings.OutputFileType))
    $data = @()
    #Dynamically Building the mandatory Software list as all environments have different output
    $buildOutputPaths |  ForEach-Object {
        if($settings.OutputFileType -eq "csv"){
            $temp = Import-Csv   $_.FullName
            $data += $temp
            }
    }


    if ( $Action -eq "ReturnData" ) {
        $data
    }
    elseif ( $Action -eq "SendEmail" ) {
        $fileName = '{0}_{1:yyyy-MM-dd}.{2}' -f $outputfileName, (Get-Date), $settings.OutputFileType
        $reportAttachement = Join-Path -Path $settings.temporaryPathforReports -ChildPath $fileName

        if ( !(Test-Path $settings.temporaryPathforReports) ) {
            New-Item -ItemType directory -Path $settings.temporaryPathforReports
            $data | Export-Csv $reportAttachement
        }
        else {
            $data | Export-Csv $reportAttachement
        }

        $emailParams = @{
            Body        = "enter the content of the email body in this variable"
            SmtpServer  = $settings.smtpserveraddress
            From        = $settings.smtpsenderaddress
            To          = "Security@lab.local"
            Subject     = [string]::Concat($outputfileName, " for ", $currentDate)
            Attachments = $reportAttachement
        }
        Send-MailMessage @emailParams
    }
}

Send-InstalledSubsystems -Action ReturnData

$shareServer = "lab-script-01"
$settings =  Get-Content "\\$shareServer\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json

. $settings.loadFunctions

Send-InstalledSubsystems -Action ReturnData