#Found online on 1/10 

$allFolders = Get-ChildItem -Path "<Folder Path>" -Directory -Recurse

foreach($Folder in $allFolders){
    $Permission = Get-Acl -Path $Folder.FullName
    $Permission.SetAccessRuleProtection($false,$true)
    Set-Acl -Path $Folder.FullName -AclObject $Permission
}
