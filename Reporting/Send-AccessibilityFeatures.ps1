
$settings =  gc "\\lab-script-01\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
$global:EnvironmentPhase = "alpha"
$outputfileName = "AccessibilityFeatures_T1015"
$buildOutputPaths =  Get-ChildItem ([string]::Concat($settings.OutputFolder,"\*\",$outputfileName, ".",$settings.OutputFileType))
$data = @()
#Dynamically Building the mandatory Software list as all environments have different output
$buildOutputPaths |  ForEach-Object {
    if($settings.OutputFileType -eq "csv"){
        $temp = Import-Csv   $_.FullName
        $data += $temp
        }
}
$data
