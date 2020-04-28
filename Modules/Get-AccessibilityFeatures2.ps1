$url = "https://www.crowdstrike.com/blog/registry-analysis-with-crowdresponse/"
$master2 = @()
$path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\"
$possiblestickyKeys =  get-childitem `
     "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\" `
     | Where-Object {$_.Property -like "Debugger"} | Select-Object PSPATH
foreach($i in $possiblestickyKeys){
    $master2 += (Get-ItemProperty $i.PSPath)
}
$master2 = $master2 | Select-Object @{name="ComputerName";expression={$env:Computername}}, `
        PSchildName,Debugger,PSPAth,@{name="reference_URL";expression={$url}}
$master2
