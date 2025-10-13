function Remove-Backups {
    param (
        [Parameter(Mandatory)]
        [string]$filePath,
        [Parameter(Mandatory)]
        [Int16]$numberOfDaysToKeep,
        [string]$directoriesOrFiles
    )
    
    #For Variable Validation
    #Write-Output "Filepath is '$filePath'"
    #Write-Output "Number of Days to Keep is '$numberOfDaysToKeep'"
    #Write-Output ""

    #Using the -Directory property will only grab Folders, while -File will only grab Files
    #$Folders = Get-ChildItem -Path <#file path#> -Directory
    
    #Check the directories or file param
    if($directoriesOrFiles -eq "Directory"){
        $Files = Get-ChildItem -Recurse -Path $filePath -Directory
    }else{
        $Files = Get-ChildItem -Recurse -Path $filePath -File
    }
    

    #Grabs the current date
    $TodaysDate = Get-Date

    #For each file in the files array, iterate through them
    $filesToBeDeleted = Foreach($File in $Files){

        #Grab time difference between todays date and files creation date, converted to Total Days (Decimal Format) 
        $timeDiff = ($TodaysDate - $File.CreationTime).TotalDays

        #For Debugging
        #Write-Warning $timeDiff.TotalDays

        #Check if time difference is greater then 30 days 
        if($timeDiff -gt $numberOfDaysToKeep){
            #For Debugging, with -Recurse flag on prints current directory before going down a level
            #Write-Host $File.Name

            Write-Host "Removing" $File.Name
            #Removes file permanently (not sent to recycle bin)
            #Remove-Item $File
        }
        
        New-Object PSObject -Property @{
            Name = $File.Name
            Type = $File.Type
            Age = $timeDiff
        }
    }
    
    $filesToBeDeleted | Select-Object Name, Type, Age | Export-Csv -Path "C:\Users\andas\OneDrive\Desktop" -NoTypeInformation -Force
}

#Call Function
Remove-Backups -filePath "C:\Users\andas\OneDrive\Desktop\Josh" -numberOfDaysToKeep 30