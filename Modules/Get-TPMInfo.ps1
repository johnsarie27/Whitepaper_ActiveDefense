$var = Get-Tpm
$keyattestation= Get-TpmSupportedFeature
if($keyattestation -ne $null)
{
    $tempv = $keyattestation
    $var = $var | Select-Object   @{name="ComputerName";expression={$env:COMPUTERNAME}} `
        , *, @{name="Get-TPMSupportedFeature";expression={"$tempv"}}
}    
else{
    $tempv = "not supported"
    $var = $var | Select-Object @{name="ComputerName";expression={$Env:COMPUTERNAME}} `
        , @{name="Get-TPMSupportedFeature";expression={"$tempv"}},*
}

$var
