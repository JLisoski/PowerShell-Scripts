#Clear Error
$Error.Clear()

#Import file paths from CSV file
$Files = Import-Csv <#file path#>

$result = foreach ($File in $Files){
    #Grab Folder Path
    $folderPath = $File.FilePaths

    #Grab ACL of current Folder
    $NewAcl = Get-Acl -Path $folderPath -ErrorAction SilentlyContinue  

    #Grab Access 
    $Access = $NewAcl.Access

    #Create PSObject that contains the current ACLs and file/folder path
    New-Object psobject -Property @{
        backupSecurity = $Access
        filePath = $folderPath
    }
}

#Export ACL backup as Clixml to the C:\TEMP
$result | Export-Clixml -Path <#file path#>
