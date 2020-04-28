
$shareList = @()
$shares = Get-SmbShare
$shares | ForEach-Object {
    $s = $_

    $share = New-Object -TypeName PSObject

    $share | Add-Member -MemberType NoteProperty -Name ComputerName -Value $env:COMPUTERNAME
    $share | Add-Member -MemberType NoteProperty -Name ShareName -Value $s.Name
    $share | Add-Member -MemberType NoteProperty -Name ShareType -Value $s.ShareType
    $share | Add-Member -MemberType NoteProperty -Name Special -Value $s.Special
    $share | Add-Member -MemberType NoteProperty -Name ShareAcl -Value $s.SecurityDescriptor

    $tempFileName = [System.IO.Path]::GetTempFileName()
    $t = Get-Acl $tempFileName
    $t.SetSecurityDescriptorSddlForm($s.SecurityDescriptor)
    $share | Add-Member -MemberType NoteProperty -Name ShareOwner -Value $t.Owner
    $share | Add-Member -MemberType NoteProperty -Name ShareGroup -Value $t.Group
    $share | Add-Member -MemberType NoteProperty -Name ShareDaclToString -Value $t.AccessToString
    Remove-Item $tempFileName -Force

    if ( $s.ShareType -eq "FileSystemDirectory" ) {
        $acl = $null
        $folder = $null
        if (Test-Path $s.Path) {
            $folder = Get-Item $s.Path
            $acl = Get-Acl $s.Path -Audit
        } else {
            $Host.UI.WriteErrorLine(("[{0}] The path {1} specified for the share {2} does not exist." -f (Get-Date -Format o),$s.Path,$s.Name))
        }

        $share | Add-Member -MemberType NoteProperty -Name Path -Value $s.Path
        $share | Add-Member -MemberType NoteProperty -Name FolderAcl -Value $acl.Sddl
        $share | Add-Member -MemberType NoteProperty -Name FolderDaclToString -Value $acl.AccessToString
        $share | Add-Member -MemberType NoteProperty -Name FolderSaclToString -Value $acl.AuditToString
       
        $share | Add-Member -MemberType NoteProperty -Name FolderOwner -Value $acl.Owner
        $share | Add-Member -MemberType NoteProperty -Name FolderGroup -Value $acl.Group
        $share | Add-Member -MemberType NoteProperty -Name FolderCreationTime -Value $folder.CreationTime
        $share | Add-Member -MemberType NoteProperty -Name FolderLastAccessTime -Value $folder.LastAccessTime
        $share | Add-Member -MemberType NoteProperty -Name FolderLastWriteTime -Value $folder.LastWriteTime
    }

    $shareList += $share
}

$shareList
