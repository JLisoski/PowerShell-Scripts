#Clear Error
$Error.Clear()

#Import file paths from CSV file
$Files = Import-Clixml -Path <#file path#>

pause

foreach ($File in $Files.filePath){
    #Grab Folder Path
    $folderPath = $File

    #For Debugging
    #Write-Host "Folder path is $folderPath"

    #Grab ACL of current Folder
    $NewAcl = Get-Acl $folderPath

    #Grab ACls
    foreach ($currACL in $Files.backupSecurity){
       

        # Set properties
        $identity = $currACL.IdentityReference

        #For Debugging
        #Write-Host "Identity is $identity"

        $fileSystemRights = $currACL.FileSystemRights

        #For Debugging
        #Write-Host "FileSystemRights are $fileSystemRights"

        $inheritanceFlag = $currACL.InheritanceFlags

        #For Debugging
        #Write-Host "InheritanceFlag are $inheritanceFlag"

        $propagationFlag = $currACL.PropagationFlags

        #For Debugging
        #Write-Host "PropagationFlag is $propagationFlag"

        $type = $currACL.AccessControlType

        #For Debugging
        #Write-Host "AccessControlType is $type"

        #Declare found variable 
        $found = $false

        #Declare temp var to hold acl data 
        $tempACL = $NewAcl.Access

        #Check if group already exists in the ACL, tested 1/10 and successful in checking
        foreach($user in $tempAcl){
            #For Debugging 
            #Write-Host $user.IdentityReference

            if($user.IdentityReference -like $identity){
                #Set found to be true
                $found = $true

                Write-Host "$identity already exists on $foldderPath"
            }
        }

        #If not found execute, tested 1/10 and correctly triggers
        if (!$found) {
            # Create new rule
            $fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $inheritanceFlag, $propagationFlag, $type
            $fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
            # Apply new rule
            $NewAcl.SetAccessRule($fileSystemAccessRule)
            Set-Acl -Path $folderPath -AclObject $NewAcl   
        }

    }
}
