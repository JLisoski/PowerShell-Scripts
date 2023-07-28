#Import file paths from CSV file
$Files = Import-Csv <#file path#>

#For Debugging, Variable to hold number of files imported
#$importedFileCount = $Files.count

#Declare counter variables
$addedTo = 0
$alreadyThere = 0

foreach ($File in $Files){
    #Grab Folder Path
    $folderPath = $File.FilePaths

    #For Debuggins (Verified 1/9 for correctly grabbing file paths)
    #Write-Host $File.FilePaths

    #Grab ACL of current Folder
    $NewAcl = Get-Acl -Path $folderPath        

    # Set properties
    $identity = "BUILTIN\Administrators"
    $fileSystemRights = "FullControl"
    $inheritanceFlag = "ContainerInherit, ObjectInherit"
    $propagationFlag = "None"
    $type = "Allow"

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

            #Increase alreadyThere
            $alreadyThere++
        }
    }

    #If not found execute, tested 1/10 and correctly triggers
    if (!$found) {

        #Increase addedTo
        $addedTo++

        # Create new rule
        $fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $inheritanceFlag, $propagationFlag, $type
        $fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
        # Apply new rule
        $NewAcl.SetAccessRule($fileSystemAccessRule)
        Set-Acl -Path $folderPath -AclObject $NewAcl -ErrorAction SilentlyContinue 
    }
}

#Have not tested the below yet but should be fine. 
#Output useful information 
Write-Host "Service account added to $addedTo folders"
Write-Host "Service account alreay existed on $alreadyThere folders"
