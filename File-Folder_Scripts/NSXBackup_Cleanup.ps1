function Remove-Backups {
    param (
        [Parameter(Mandatory)]
        [string]$filePath,
        [Parameter(Mandatory)]
        [Int16]$numberOfDaysToKeep
    )
    
    #For Variable Validation
    Write-Output "Filepath is '$filePath'"
    Write-Output "Number of Days to Keep is '$numberOfDaysToKeep'"
    Write-Output ""

    #Using the -Directory property will only grab Folders, while -File will only grab Files
    #$Folders = Get-ChildItem -Path <#file path#> -Directory
    $Files = Get-ChildItem -Path $filePath -File

    #Grabs the current date
    $TodaysDate = Get-Date

    #For each file in the files array, iterate through them
    Foreach($File in $Files){

        #Grab time difference between todays date and files creation date, converted to Total Days (Decimal Format) 
        $timeDiff = ($TodaysDate - $File.CreationTime).TotalDays

        #For Debugging
        #Write-Warning $timeDiff.TotalDays

        #Check if time difference is greater then 30 days 
        if($timeDiff -gt $numberOfDaysToKeep){
            #For Debugging
            Write-Host $File.Name

            #Removes file permanently (not sent to recycle bin)
            #Remove-Item $File
        }
    }
}

Remove-Backups #-filePath "C:\Users\andas\OneDrive\Desktop\Josh" -numberOfDaysToKeep 2