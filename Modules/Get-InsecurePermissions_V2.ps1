<#
   Credit goes to Astrix Systems as this script was built 
   off https://github.com/astrixsystems/Secure-WindowsServices/

#>
Function Get-InsecurePermissions {
	Param(
		[Parameter(Mandatory=$true)][String]$Path, 
        	[Parameter(Mandatory=$true)][string]$folderorFile,
        	[Parameter(Mandatory=$true)][string]$startName
	)
	$ACL = Get-ACL $Path;
	$AccessACL = $ACL | Select-Object -Expand Access;
			
	ForEach ($ace in $AccessACL) {
		$SecurityPrincipal = $ace.IdentityReference;
	    $Permissions = $ace.FileSystemRights.ToString() -Split ", ";
		
        ForEach ($Permission in $Permissions){
			If ((($Permission -eq "FullControl") -or ($Permission -eq "Modify") -or ($Permission -eq "Write")) `
                -and (($SecurityPrincipal -eq "Everyone") -or ($SecurityPrincipal -eq "NT AUTHORITY\Authenticated Users") `
                -Or ($SecurityPrincipal -eq "BUILTIN\Users") -or ($SecurityPrincipal -like "*Domain Users"))) {
		    	  $InsecurePermissionsFound = $True;					
				  $ourObject = New-Object -TypeName psobject 
				  $ourObject | Add-Member -MemberType NoteProperty -Name ComputerName -Value $env:computername
				  $ourObject | Add-Member -MemberType NoteProperty -Name StartName  -Value $startName
				  $ourObject | Add-Member -MemberType NoteProperty -Name Path   -Value $path
				  if($folderorFile -eq "file"){ $objecttype = "file"}
				  elseif($folderorFile -eq "folder"){ $objecttype = "folder"}
				  $ourObject | Add-Member -MemberType NoteProperty -Name Is_objectFolderorFile -Value $objecttype
				  $ourObject | Add-Member -MemberType NoteProperty -Name Permissions   -Value $Permission
				  $ourObject | Add-Member -MemberType NoteProperty -Name SecurityPrincipal   -Value $securityPrincipal
				  [void]$badPermissions.Add($ourObject)	             
			}
		}
	}
}

[System.Collections.ArrayList]$badPermissions = @()
[System.Collections.ArrayList]$FilesChecked = @()
[System.Collections.ArrayList]$FoldersChecked = @()
			
$WindowsServices = Get-WmiObject Win32_Service | Select-Object Name, DisplayName, PathName,startName | Sort-Object DisplayName
$WindowsServices | ForEach-Object {	
	$i = ($i + 1)
	$WindowsService_Path = $_.PathName
	$WindowsService_File_Path = ($WindowsService_Path -Replace '(.+exe).*', '$1').Trim('"')
    if([string]::IsNullOrWhiteSpace($WindowsService_File_Path) -eq $false ){
        $WindowsService_Folder_Path = Split-Path -Parent $WindowsService_File_Path
        $windowsService_startName = $_.startname
        if ($FoldersChecked -NotContains $WindowsService_Folder_Path){
		    $FoldersChecked += $WindowsService_Folder_Path
		    Get-InsecurePermissions -Path $WindowsService_Folder_Path -folderorFile "folder" -startName $windowsService_startName
	    }			
	    if ($FilesChecked -notContains $WindowsService_File_Path){
		    $FilesChecked += $WindowsService_File_Path
		    Get-InsecurePermissions -Path $WindowsService_File_Path -folderorFile "file" -startName $windowsService_startName
	    }
    }
}
$badPermissions
