#Used to Disable Stale AD accounts

#Import the Distinguished Names of the Stale Ad Accounts from a .csv file and pipe to a ForEach-Object to disable
Import-Csv <#file path#> | ForEach-Object {
    $distinguishedName = $_."DistinguishedName"

    #For Debugging
    #Write-Host $distinguishedName

    #Grabs the AD account using the distinguished name and then pipes to disabling that account. 
    Get-ADUser -Server "c1b.corp" -Identity $distinguishedName | Disable-ADAccount

    #Rollback Option, grabs Ad Account and pipes to Enable that account
    #Get-ADUser -Server "c1b.corp" -Identity $distinguishedName | Enable-ADAccount
}
