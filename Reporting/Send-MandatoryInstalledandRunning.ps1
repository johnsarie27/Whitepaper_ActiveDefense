
$settings =  gc "\\lab-script-01\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json

$buildOutputPaths =  Get-ChildItem ([string]::Concat($settings.OutputFolder,"\*\","installedSoftware.",$settings.OutputFileType))
$data = @()
#Dynamically Building the mandatory Software list as all environments have different output
$buildOutputPaths |  ForEach-Object {
    if($settings.OutputFileType -eq "csv"){
        $temp = Import-Csv   $_.FullName
        $countofMandatorySoftware = $settings.SecuritySoftware.Count
        $listOfMandatorySoftware = $settings.SecuritySoftware
        $computername = $temp | Select-Object ComputerName -Unique
  
        $ret = New-Object PSObject
        $ret | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $computername.ComputerName

        for($i = 0; $i -lt $countofMandatorySoftware; $i++){
            $tempSoftware =[string]::Concat($listOfMandatorySoftware[$i].RegistryKeyWord,"*");
            if($temp.displayname -like $tempSoftware){
               $name =  [string]::Concat($listOfMandatorySoftware[$i].RegistryKeyWord, "_Installed")
               $ret | Add-Member -MemberType NoteProperty -Name $name -Value $true
            }
            else{
               $name =  [string]::Concat($listOfMandatorySoftware[$i].RegistryKeyWord, "_Installed")
               $ret | Add-Member -MemberType NoteProperty -Name $name -Value $false
            }   
          }
          $data += $ret
        }
}


$data
# SIG # Begin signature block
# MIIHNgYJKoZIhvcNAQcCoIIHJzCCByMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUd8STT/1IxPef/a1rFtxhuLxk
# zyygggShMIIEnTCCBESgAwIBAgITYQAAAAedH0A3IMLoeQAAAAAABzAKBggqhkjO
# PQQDAjBHMRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxEzARBgoJkiaJk/IsZAEZFgNs
# YWIxGTAXBgNVBAMTEGxhYi1MQUItQ0EtMDEtQ0EwHhcNMjAwMjA4MTkwOTAyWhcN
# MjIwMjA3MTkwOTAyWjAkMSIwIAYDVQQDExlMQUJDb2RlU2lnbmluZ0NlcnRpZmlj
# YXRlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtZ3fgTxf2DMjqcU9
# 0soylzNJwi1+3841eZ8kL3rTsAswjo16bI7qwxjXWdlcwkQEPNkoRwIDt+xWCZkE
# Ha4Jhal8maeKu+kTsP/tunhuWbIcQMpc8CKSwg7rgHXhfJYsCqwuM0b1MQQhEdiL
# XONqlmdem58oJydV5uTK3KqHHRwN0Z+4k84Hjt5OkudiQz+/v9/9PuYQdGQspNAd
# 1amoCW2GaS9y4Uqh3/y4x2cHbd1jY8jHKTlVtXV/1zEIJdvIZungWhVGG06L6hjC
# kE9UrGE/F5Vhq4FqcrbRI7Sx31/f2vgEIrJ7tOAqnhtSxGQWz24K+XyH/Zeh/19T
# 2mzdKwIDAQABo4ICZTCCAmEwOwYJKwYBBAGCNxUHBC4wLAYkKwYBBAGCNxUIg4rr
# BoXL8DyBiYUL6o9qg4b+RmyF3aNA2rEMAgFkAgEDMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMBsGCSsGAQQBgjcVCgQO
# MAwwCgYIKwYBBQUHAwMwHQYDVR0OBBYEFLacxubNl5U7CQn9V983Lp+z/Z46MB8G
# A1UdIwQYMBaAFMhXY3OWycWedj6aQJPC3vx1Ys01MIHOBgNVHR8EgcYwgcMwgcCg
# gb2ggbqGgbdsZGFwOi8vL0NOPWxhYi1MQUItQ0EtMDEtQ0EsQ049TEFCLUNBLTAx
# LENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxD
# Tj1Db25maWd1cmF0aW9uLERDPWxhYixEQz1sb2NhbD9jZXJ0aWZpY2F0ZVJldm9j
# YXRpb25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9Y1JMRGlzdHJpYnV0aW9uUG9pbnQw
# gcAGCCsGAQUFBwEBBIGzMIGwMIGtBggrBgEFBQcwAoaBoGxkYXA6Ly8vQ049bGFi
# LUxBQi1DQS0wMS1DQSxDTj1BSUEsQ049UHVibGljJTIwS2V5JTIwU2VydmljZXMs
# Q049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1sYWIsREM9bG9jYWw/Y0FD
# ZXJ0aWZpY2F0ZT9iYXNlP29iamVjdENsYXNzPWNlcnRpZmljYXRpb25BdXRob3Jp
# dHkwCgYIKoZIzj0EAwIDRwAwRAIgfBJxC4oZWNAJeZb6NUu3YfTQePYNF6oXfnsw
# /LgucYgCIFx7LYe2vHTF+YYtRl6idp8sgBNvbgi+fTg+Jyx5Fi4wMYIB/zCCAfsC
# AQEwXjBHMRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxEzARBgoJkiaJk/IsZAEZFgNs
# YWIxGTAXBgNVBAMTEGxhYi1MQUItQ0EtMDEtQ0ECE2EAAAAHnR9ANyDC6HkAAAAA
# AAcwCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZI
# hvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcC
# ARUwIwYJKoZIhvcNAQkEMRYEFHzuDCmFop/skfJ9yCLeqAG9Oz3CMA0GCSqGSIb3
# DQEBAQUABIIBADuFiTvzmC0l8DmaIuVucArBZg81rQtZfZsdFZjQ+kZOsGhv+KM1
# lR2m11Q9cEQcCjnFHzlCJuNMxv912JyY4syhx9JH+Ls7upqsWW08ytGKD2f1se3o
# cDyjgr5oL0Ii9Lq24wfWwrCze7vUA3N87lDi55uGUecYk/XbgUtBH75QHDYLpfjV
# w1qtNrSYp1OrWA4grmuT1atp911k+Yqw9QzfqtHQIY2xtwfsUA/BhkBt2IIcLAXQ
# 4tu/QJsr36a5IN7V8MCZqiYe+WaP5l2hw7xKfDxWFFuC0NJljkvIOXDlSydcKgKe
# sg/dFgK9bwi8VshUEou7mSgTUFPCwZem7qo=
# SIG # End signature block
