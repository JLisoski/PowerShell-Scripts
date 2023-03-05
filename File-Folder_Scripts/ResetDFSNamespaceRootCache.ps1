<#
.SYNOPSIS
Iterates through a domains namespaces and sets cache duration to desired time for each namepsace and corresponding folders. 
.DESCRIPTION
Enter domain name to work with in the variable at the top. Script will grab all namespace roots that exist for that domain, check the root time to live and set to desired cache duration if not alredy what we want. Then, it will iterate through each namespace root and check each the time to live for each folder within that naemspace root.   
#>

#Create Domain Variable 
$Domain = <#Domain Name#> 

#Create desired Time to Live variables for Roots and Folders
$desiredRootDuration = 300 
$desiredFolderDuration = 300

#Create CIM Session to File Server 
#$session = New-CimSession -ComputerName DRFILE01N01.c1b.corp -Credential $creds 

#Grabs all namespaces with given domain
$namespaceRoots = Get-DfsnRoot -Domain $Domain

#Prints all paths in the domainc
$namespaceRoots

#Move through namespaceRoots array 
Foreach($root in $namespaceRoots){
    #For Debugging 
    #Write-Host "Root Path is " $root.Path
    #Write-Host "Root Time to live is " $root.TimeToLiveSec

    #Create variable to hold the root path 
    $namespacePath = $root.Path

    #Check if TimeToLiveSec is set to desired time, if not update 
    <#
    if($root.TimeToLiveSec -ne $desiredRootDuration){
        Set-DfsnRoot -Path "$namespacePath" -TimeToLiveSec 300 
    }
    #>

    #Grab all folders under given root path (Path has to be in quotes and end with \*)
    $namespaceFolders = Get-DfsnFolder -Path "$namespacePath\*"

    #For Debugging, print out Path name and TimeToLiveSec for each folder in the namespaceRoot 
    Foreach ($folder in $namespaceFolders){

        #For Debugging
        #Write-Host "Folder Path is " $folder.Path
        #Write-Host "Folder Time to Live is " $folder.TimeToLiveSec

        #Set Folder Path Variable 
        $folderPath = $folder.Path

        #Check if TimeToLiveSec is set to desired time, if not update 
        <#
        if($folder.TimeToLiveSec -ne $desiredFolderDuration){
            Set-DfsnFolder -Path "$folderPath" -TimeToLiveSec 300
        }
        #>
    }

    #Prints out all folders under the current root. For Validation purposes.   
    $namespaceFolders | Out-GridView -Title $root.Path
}
