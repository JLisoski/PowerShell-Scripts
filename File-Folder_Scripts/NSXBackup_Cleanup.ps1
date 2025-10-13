function Remove-Backups {
    param (
        [Parameter(Mandatory)]
        [string]$filePath,
        [Parameter(Mandatory)]
        [Int16]$numberOfDaysToKeep
    )
    
    #For Variable Validation
    #Write-Host "Filepath is '$filePath'"
    #Write-Host "Number of Days to Keep is '$numberOfDaysToKeep'"
    #Write-Host ""

    #Using the -Directory property will only grab Folders, while -File will only grab Files
    
    #Grab all the files in the Path
    $Files = Get-ChildItem -Recurse -Path $filePath -File


    #Grabs the current date
    $TodaysDate = Get-Date

    #For each file in the files array, iterate through them
    $filesToBeDeleted = Foreach($File in $Files){

        #Grab time difference between todays date and files creation date, converted to Total Days (Decimal Format) 
        $timeDiff = ($TodaysDate - $File.CreationTime).TotalDays

        #For Debugging
        #Write-Warning $timeDiff.TotalDays

        #Check if time difference is greater then numberOfDaysToKeep 
        if($timeDiff -gt $numberOfDaysToKeep){
            #For Debugging, with -Recurse flag on prints current directory before going down a level
            Write-Host "Removing" $File.Name

            #Create PSObject to retain deleted file/directory information
            New-Object PSObject -Property @{
                Name = $File.Name
                Age_Days = $timeDiff
                Location = $File.FullName
            }
            
            #Removes file permanently (not sent to recycle bin)
            #Remove-Item -Path $File.FullName -Force
        }
        
    }
    
    if($filesToBeDeleted -ne $null){
      #Export deleted files/folders as a CSV to a log folder location for historical data
      $filesToBeDeleted | Select-Object Name, Age_Days, Location | Export-Csv -Path "" -NoTypeInformation -Force
    }
    
    #For Debugging
    #$filesToBeDeleted | Out-GridView
    
    #Reset timeDiff back to 0
    $timeDiff = 0
    
    #Clean up the empty directories left over
    $Directorires = Get-ChildItem -Recurse -Path $filePath -Directory
    
    $directoriesToBeDeleted = Foreach($Directory in $Directorires){
        #Grab time difference between todays date and files creation date, converted to Total Days (Decimal Format) 
        $timeDiff = ($TodaysDate - $Directory.CreationTime).TotalDays

        #For Debugging
        #Write-Warning $timeDiff.TotalDays

        #Check if time difference is greater then numberOfDaysToKeep 
        if($timeDiff -gt $numberOfDaysToKeep){
            #For Debugging, with -Recurse flag on prints current directory before going down a level
            #Write-Host $Directory.Name
            Write-Host "Removing" $Directory.Name
            
            #Check if Directory is Empty, if it is delete
            if(-not (Get-ChildItem -Path $Directory.FullName -Force)){
              #Create PSObject to retain deleted file/directory information
              New-Object PSObject -Property @{
                Name = $Directory.Name
                Age_Days = $timeDiff
                Location = $Directory.FullName
              }
            
            
              #Removes file permanently (not sent to recycle bin)
              #Remove-Item -Path $Directory.FullName -Recurse -Force
            }else{
              #Directory has files and does not need to be deleted
              
              #For Debugging
              Write-Host $Directory.FullName "has content!"
            }
        }
    }
    
    if($directoriesToBeDeleted -ne $null){
      #Export deleted files/folders as a CSV to a log folder location for historical data
      $directoriesToBeDeleted | Select-Object Name, Age_Days, Location | Export-Csv -Path "" -NoTypeInformation -Force
    }
    
    #For Debugging
    #$directoriesToBeDeleted | Out-GridView
}

#Clear Error variable 
$Error.Clear()

#Grab credentials to log in to remote server with
$creds = Get-Credential

#Invoke Command on SFTP Server
Invoke-Command -ErrorAction SilentlyContinue -ComputerName <Server> -Credential $creds -ScriptBlock{
    #For Debugging 
    Write-Host "Inside the Invoke Command"

    #Call Function
    Remove-Backups -filePath "" -numberOfDaysToKeep 2
    
    #For Debugging
    Write-Host "Exiting the Invoke Command"
}

#For Debugging
Write-Host "Outside the Invoke Command"

#For local use
#Remove-Backups -filePath "" -numberOfDaysToKeep 2
