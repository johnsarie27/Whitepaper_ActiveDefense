function Send-InstalledSubsystems {
        [cmdletbinding()]
        Param(
        [parameter(ValueFromPipeline)]
        [ValidateSet('SendEmail','ReturnData')]
        [string[]]$Action
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

      
        if($Action -eq "ReturnData"){  $data}
        elseif($Action -eq "SendEmail"){
            $reportAttachement = [string]::Concat($settings.temporaryPathforReports,$outputfileName,"_$currentDate",".",$settings.OutputFileType)
            if(!(Test-Path $settings.temporaryPathforReports)){
                New-Item -ItemType directory -Path $settings.temporaryPathforReports
                $data | Export-Csv $reportAttachement
            }
            else{$data | Export-Csv $reportAttachement} 

            $emailTo = "Security@lab.local"
            $emailsubject = [string]::Concat($outputfileName, " for ", $currentDate)
            $emailbody = "enter the content of the email body in this variable"

            Send-MailMessage -SmtpServer ($settings.smtpserveraddress) -From $settings.smtpsenderaddress -To $emailTo `
                 -Subject $emailsubject -Attachments $reportAttachement
        }

}

Send-InstalledSubsystems -Action ReturnData

$shareServer = "lab-script-01"
$settings =  gc "\\$shareServer\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json

. $settings.loadFunctions

Send-InstalledSubsystems -Action ReturnData