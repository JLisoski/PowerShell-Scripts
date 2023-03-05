#Script will output any folders/files that Local Admins was not found on
#If no ouput, Local Admins found on all folders 

#Clear Error
$Error.Clear()

#Import file paths from CSV file
$Files = Import-Csv <#file path#>

#For Debugging, Variable to hold number of files imported
#$importedFileCount = $Files.count

foreach ($File in $Files){
    #Grab Folder Path
    $folderPath = $File.FilePaths

    #For Debuggins (Verified 1/9 for correctly grabbing file paths)
    #Write-Host $File.FilePaths

    #Grab ACL of current Folder
    $NewAcl = Get-Acl -Path $folderPath -ErrorAction SilentlyContinue     

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

        if($user.IdentityReference -eq $identity){
            #Set found to be true
            $found = $true
        }
    }

    #If not found execute, tested 1/10 and correctly triggers
    if (!$found) {
        #Output which folder Local Admins not found on
        Write-Host "$identity not found on $folderPath"
    }
}
