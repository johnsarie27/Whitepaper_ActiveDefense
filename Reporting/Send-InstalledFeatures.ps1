﻿
$settings =  gc "\\lab-script-01\Scripts\GlobalSettings\settings.json" | ConvertFrom-Json
$global:EnvironmentPhase = "alpha"
$outputfileName = "getinstalledfeatures"
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
# SIG # Begin signature block
# MIIHNgYJKoZIhvcNAQcCoIIHJzCCByMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUBNKa5r8U03MxueBbInZa7FYW
# Q0+gggShMIIEnTCCBESgAwIBAgITYQAAAAedH0A3IMLoeQAAAAAABzAKBggqhkjO
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
# ARUwIwYJKoZIhvcNAQkEMRYEFCYi02wAKiTnZJFQl2SOIIjO2lDdMA0GCSqGSIb3
# DQEBAQUABIIBAFR1sW4b8x7+nhzXVRWcfVEVcA3OVHVIelF48Wu3axICBoDv43mE
# 35pgx75Y1e3kLuG1dcY7TfCdKS384fPO/dDkLns4fA/lngg5c9ZeJYN9gvF3r8dE
# +3S0IFrV/r3wkFKHKUtI3oiHTYnMv6/8a/im9wiemwHW9K/6BH9X6v6Q81xfOzpI
# yccvVkstIj1oVEZM44S5hascsBtzs3v8ghWKIfkf/Lb8FzBISZ9xCJhL0RK5FrBS
# ooi8Yd9N+Jmz7r/atU3CsHnr63npAkxdCbp5dR/+FLhLxUSdnqtcn5UzN90ABpxD
# tJPvRCXJTamyFp5x2X4pIZyPsSj1OP2z2ks=
# SIG # End signature block
