#Grab URLs from text file 
$URLList = Get-Content <#file path#> 

#Check if URL List is empty or not
If(!$URLList){
    Write-Host "No URLs present in the given text file!"
}

#Loop through extracted URLs and output status code
$URLTable = ForEach($Url in $URLList){

    #Try/Catch block for the Invoke-WebRequest
    try{
        $Response = Invoke-WebRequest -Uri $Url
        $StatusCode = $Response.StatusCode
    }catch{
        $StatusCode = $_.Exception.Response.StatusCode.value__
    }

    #Outputs status code and corresponding URL 
    #Write-Host "$StatusCode - $Url"

    #Make a psobject to be able to output a table 
    New-Object psobject -Property @{
        Website = $Url
        URL_Status = $StatusCode
    }
}

#Output the table
$URLTable | Format-Table Website, URL_Status
