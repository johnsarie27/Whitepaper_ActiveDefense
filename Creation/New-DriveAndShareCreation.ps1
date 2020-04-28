$driveLetter = "K"
$driveSize =  10gb
$newDriveName = "Compliance"
$shareName = "ComResults"

New-Partition -DiskNumber 0 -size $driveSize -DriveLetter $driveLetter
Format-Volume -DriveLetter $driveLetter -FileSystem NTFS
Set-Volume -DriveLetter $driveLetter -NewFileSystemLabel $newDriveName

$createdDrive = Get-PSdrive | where-object {$_.Name -eq $driveLetter}
#creating folder structure
$newSharePath = ([string]::Concat($createdDrive.Root, $shareName))
New-Item -Path $newSharePath  -ItemType Directory 
New-SmbShare -Path $newSharePath -name $shareName


$user_account='Creator Owner'
$Acl = Get-Acl $newSharePath
$Ar = New-Object system.Security.AccessControl.FileSystemAccessRule($user_account, "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$Acl.Setaccessrule($Ar)
Set-Acl $newSharePath $Acl 

$user_account='Domain Computers'
$Acl = Get-Acl $newSharePath
$Ar = New-Object system.Security.AccessControl.FileSystemAccessRule($user_account, "ReadandExecute", "ContainerInherit, ObjectInherit", "None", "Allow")
$Acl.Setaccessrule($Ar)
Set-Acl $newSharePath $Acl 