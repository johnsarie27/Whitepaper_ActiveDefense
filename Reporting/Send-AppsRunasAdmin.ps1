
$settings =  gc "\\lab-script-01\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
$global:EnvironmentPhase = "alpha"
$outputfileName = "ProcessesV2"
$buildOutputPaths =  Get-ChildItem ([string]::Concat($settings.OutputFolder,"\*\",$outputfileName, ".",$settings.OutputFileType))
$browsers = @('iexplore','firefox','chrome','MicrosoftEdge','outlook')
$data = @()

$buildOutputPaths |  ForEach-Object {
    if($settings.OutputFileType -eq "csv"){
        $temp = Import-Csv   $_.FullName
        $data = $temp |Where-Object {$_.ProcessName -in  $browsers} | Select-Object ComputerName,ProcessName,UserName,Path
        }
}
$data
