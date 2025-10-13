#Using the -Directory property will only grab Folders, while -File will only grab Files
#$Folders = Get-ChildItem -Path <#file path#> -Directory
$Files = Get-ChildItem -Path "C:\Users\andas\Downloads" -File

#Grabs the current date
$TodaysDate = Get-Date

#For each file in the files array, iterate through them
Foreach($File in $Files){

    #Grab time difference between todays date and files creation date, converted to Total Days (Decimal Format) 
    $timeDiff = ($TodaysDate - $File.CreationTime).TotalDays

    #For Debugging
    #Write-Warning $timeDiff.TotalDays

    #Check if time difference is greater then 30 days 
    if($timeDiff -gt 30){
        #For Debugging
        Write-Host $File.Name

        #Removes file permanently (not sent to recycle bin)
        #Remove-Item $File
    }
}
