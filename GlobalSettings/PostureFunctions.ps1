$shareServer = "lab-script-01"
$settings =  gc "\\$shareServer\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json

function Create-Report {
     <#
    .SYNOPSIS
        Generates a report and outputs in the specified folder
    .DESCRIPTION
        This function runs the specified script and outputs to file
    .EXAMPLE
        PS C:\> generateReport -filename Processes -fileType csv -scriptvariable $Proc -outputFolder \\Lab-script-01\ComputerResults\$env:ComputerName
        This generates a report and outputs the file into the UNC patch specified
    .INPUTS
        None
    .PARAMETER fileName
        file name of the output file
    .PARAMETER filetype
        file output type can be json or csv
    .PARAMETER scriptVariable
       used to specify the script that will be executed
    .PARAMETER outputFolder
        specify the output folder 
    .OUTPUTS
        None
    .NOTES
        This function 
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $filename,
        [Parameter(Mandatory = $true)]
        [ValidateSet("json","csv" )]
        [string]
        $fileType = "csv",
        [Parameter(Mandatory = $true)]
        [string]
        $scriptvariable,
        [Parameter(Mandatory = $true)]
        [string]
        $outputFolder
    )
    
    if($fileType -eq "json"){
        Invoke-Expression $scriptvariable | Where-Object {$_} | ConvertTo-Json `
            | Out-File -Force ([string]::Concat($outputFolder,"\",$filename,".",$fileType)) 
    }
    elseif($fileType -eq "csv"){
        Invoke-Expression $scriptvariable | Where-Object {$_} `
        | Export-Csv -Path ([string]::Concat($outputFolder,"\",$filename,".",$fileType)) -NoTypeInformation -Force
    }
} 

function Get-ActiveDefenseGlobalSettings{
    $settings = Get-Content -Path "\\$shareServer\Scripts\alpha\settings.json" | ConvertFrom-Json
    return $settings
}

function Set-ActiveDefenseGlobalSetting([string] $key){
    $settings = Get-Content -Path "\\$shareServer\Scripts\alpha\settings.json" | ConvertFrom-Json

}

function AddSHA256CMDFileHashToMasterList([string] $path, [string] $algo, [string]$hash, [string] $os){
    $importedCMDFileHash =@()
    if(!(Test-Path ([string]::Concat($settings.CmdFileHashLocation,$settings.CmdFileHashFileName)))){
        New-Item -Path $settings.CmdFileHashLocation -ItemType File -Name ($settings.CmdFileHashFileName)
    }else{
      $importedCMDFileHash +=  IMport-csv ([string]::Concat($settings.CmdFileHashLocation,$settings.CmdFileHashFileName))
    }
    $obj = New-Object -TypeName psobject
    $obj | Add-Member -MemberType NoteProperty -Name Algorithm -Value $algo
    $obj | Add-Member -MemberType NoteProperty -Name Hash -Value $hash
    $obj | Add-Member -MemberType NoteProperty -Name Path -Value $path
    $obj | Add-Member -MemberType NoteProperty -Name OperatingSystem -Value $os
    $importedCMDFileHash += $obj    
    $importedCMDFileHash | Export-Csv ([string]::Concat($settings.CmdFileHashLocation,$settings.CmdFileHashFileName)) `
         -NoTypeInformation -Force
}


function Remove-LastRunForAll {
    $settings =  gc "\\$shareServer\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
    $buildOutputPaths =  Get-ChildItem ([string]::Concat($settings.OutputFolder,"\*\",$settings.LastRunTimeFileName))
    $buildOutputPaths |  ForEach-Object { Remove-Item -Path $_.FullName }
}


function Remove-LastRunForMachine ([string] $MachineName) {
    $settings =  gc "\\$shareServer\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
    $buildOutputPaths =  Get-ChildItem ([string]::Concat($settings.OutputFolder,"\$MachineName\",$settings.LastRunTimeFileName))
    $buildOutputPaths |  ForEach-Object { Remove-Item -Path $_.FullName }
}

function Remove-LastRunForMachineRegex ([regex] $regex) {
    $settings =  gc "\\$shareServer\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
    $listOfMachines= (get-childItem $settings.OutputFolder).Name  | Where-Object {$_ -match $regex}    
    $listOfMachines | ForEach-Object {
        $buildOutputPath =  ([string]::Concat($settings.OutputFolder,"\$_\",$settings.LastRunTimeFileName))
        if(Test-Path $buildOutputPath){
            Remove-Item -Path $buildOutputPath -Verbose
        }
    }  
}

function Get-RegistryandServiceValuesForMandatorySoftware([string]$vendor){
    $services = Get-service | Where-Object {$_.name -like "*$vendor*"}
    $listofInstalledSoftware = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* `
            | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate, URLInfoAbout, UninstallString, InstallLocation 
    $listofInstalledSoftware += Get-ItemProperty  HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* `
            | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate, URLInfoAbout, UninstallString, InstallLocation 
    $listofInstalledSoftware = $listofInstalledSoftware | Where-Object {$_.displayname -ne "" -and $_.displayname -ne $null} `
            | Select-Object @{name="ComputerName";expression={$env:COMPUTERNAME}}, * |  Sort-Object DisplayName
    $registryValue = $listofInstalledSoftware | Where-Object {$_.displayname -like "*$vendor*"}
    Write-Host "DisplayName in Registry: `t" $registryValue.DisplayName
    Write-Host "ServiceName: `t`t`t`t"$services.Name
}

function Sign-PowerShellCodeScripts{
    [cmdletbinding()]
    Param(
        [parameter(ValueFromPipeline)]
        [ValidateSet('Directory','File')]
        [string[]]$directoryorFile,
        [string]$pfxcertPath,
        [string]$scriptPath
    )
    $cert = Get-PfxCertificate $pfxcertPath
    if($directoryorFile.ToLower() -eq "File"){
            Set-AuthenticodeSignature -FilePath $scriptPath -Certificate $cert
    }
    elseif($directoryorFile.ToLower() -eq "Directory" -and $scriptPath -like "*"){
          $fileList = gci $scriptPath        
          foreach($file in $fileList){
              Set-AuthenticodeSignature -FilePath $file.fullname -Certificate $cert
          }  
    }
}



function Security-GetServersAccountisinAdministratorsGroup ([string]$samaccountname){
    $todaysDate = Get-Date
    $list = gci "E:\shares\ComputerResults\*\Get-LocalGroupMembership.csv" | `
        Where-Object {$_.length -gt 0 -and $_.lastwritetime -gt $todaysdate.AddDays(-30)}
    $filelist = $list | Select-Object FullName
    $MasterList = @()
    foreach($file in $filelist){
        $temp = import-csv $file.FullName
        $MasterList += $temp

    }
    $MasterList2 = $MasterList | Where-Object {$_.samaccountname -like $samaccountname -or $_.name -like $samaccountname} 
    $MasterList2
}


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
function Send-InsecureServicePermissions {
        [cmdletbinding()]
        Param(
        [parameter(ValueFromPipeline)]
        [ValidateSet('SendEmail','ReturnData')]
        [string[]]$Action
        )
        $settings =  gc "\\lab-script-01\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
        $outputfileName = "InsecurePermissions2"
        $currentDate = [datetime]::Today.ToString('MM-dd-yyyy')
        $buildOutputPaths =  Get-ChildItem ([string]::Concat($settings.OutputFolder,"\*\",$outputfileName, ".",$settings.OutputFileType))
        $data = @()
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
            Send-MailMessage -SmtpServer ($settings.smtpserveraddress) -From ($settings.smtpsenderaddress) -To $emailTo `
                 -Subject $emailsubject -Attachments $reportAttachement
        }
}

function Search-InstalledSoftware([string] $searchstring){
    $settings =  gc "\\lab-script-01\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
    $outputfileName = "InstalledSoftware"
    $buildOutputPaths =  Get-ChildItem ([string]::Concat($settings.OutputFolder,"\*\",$outputfileName, ".",$settings.OutputFileType))
    $data = @()
    $buildOutputPaths |  ForEach-Object {
        if($settings.OutputFileType -eq "csv"){
            $temp = Import-Csv   $_.FullName
            $data += $temp
         }
    }
    $return = $data | Where-Object {$_ -match "$searchstring"}
    $return
}


function Search-InstalledFeatures([string] $searchstring){
    $settings =  gc "\\lab-script-01\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
    $outputfileName = "getinstalledfeatures"
    $buildOutputPaths =  Get-ChildItem ([string]::Concat($settings.OutputFolder,"\*\",$outputfileName, ".",$settings.OutputFileType))
    $data = @()
    $buildOutputPaths |  ForEach-Object {
        if($settings.OutputFileType -eq "csv"){
            $temp = Import-Csv   $_.FullName
            $data += $temp
         }
    }
    $return = $data | Where-Object {$_ -match "$searchstring"}
    $return
}

function Get-InstalledFeatures{
    $settings =  gc "\\lab-script-01\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
    $outputfileName = "getinstalledfeatures"
    $buildOutputPaths =  Get-ChildItem ([string]::Concat($settings.OutputFolder,"\*\",$outputfileName, ".",$settings.OutputFileType))
    $data = @()
    $buildOutputPaths |  ForEach-Object {
        if($settings.OutputFileType -eq "csv"){
            $temp = Import-Csv   $_.FullName
            $data += $temp
         }
    }
    $return = $data | Group-Object Displayname | Where-Object {$_.name -ne ""} |  Sort-Object Name | Select-Object Name, Count
    $return
}



function Search-AllReports([string] $searchstring){
    $settings =  gc "\\lab-script-01\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
    $outputfileName = "InstalledSoftware"
    $buildOutputPaths =  (Get-ChildItem ([string]::Concat($settings.OutputFolder,"\*") ) -Recurse)
    $data = @()
    $buildOutputPaths |  ForEach-Object {
        if($settings.OutputFileType -eq "csv"){
            $temp = Import-Csv   $_.FullName
            $data += $temp
         }
    }
    $return = $data | Where-Object {$_ -match "$searchstring"}
    $return
}

function Search-ChromeExtensions{
    $settings =  gc "\\lab-script-01\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
    $outputfileName = "ChromeExtensions"
    $buildOutputPaths =  Get-ChildItem ([string]::Concat($settings.OutputFolder,"\*\",$outputfileName, ".",$settings.OutputFileType))
    $data = @()
    $buildOutputPaths |  ForEach-Object {
        if($settings.OutputFileType -eq "csv"){
            $temp = Import-Csv   $_.FullName
            $data += $temp
         }
    }
    $data
}

function Search-FirefoxExtensions{
    $settings =  gc "\\lab-script-01\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
    $outputfileName = "FireFoxExtensions"
    $buildOutputPaths =  Get-ChildItem ([string]::Concat($settings.OutputFolder,"\*\",$outputfileName, ".",$settings.OutputFileType))
    $data = @()
    $buildOutputPaths |  ForEach-Object {
        if($settings.OutputFileType -eq "csv"){
            $temp = Import-Csv   $_.FullName
            $data += $temp
         }
    }
    $data
}

function Search-MandatorySoftwareStatus{
    $settings =  gc "\\lab-script-01\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
    $outputfileName = "mandatorySoftware"
    $buildOutputPaths =  Get-ChildItem ([string]::Concat($settings.OutputFolder,"\*\",$outputfileName, ".",$settings.OutputFileType))
    $data = @()
    $buildOutputPaths |  ForEach-Object {
        if($settings.OutputFileType -eq "csv"){
            $temp = Import-Csv   $_.FullName
            $data += $temp
         }
    }
    $data
}

