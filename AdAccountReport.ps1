#Generates a report on a list of provided ADAccounts (by distinguished name) in the specified domain

#Clear Error
$Error.Clear()

$users = Import-Csv <#file path#>

$result = foreach($user in $users){

    #Grab ADUSer
    $currentUser = Get-ADUser -Server <#domain name#> -Properties * -Identity $user.DistinguishedName

    #For Debugging
    #Write-Host $currentUser.Name

    $timestamp = [datetime]::FromFileTime($currentUser.LastLogonTimestamp)

    if($timestamp.Year -eq 1600) {
        $timestamp = $null
    }

    New-Object psobject -Property @{
        Name = $currentUser.Name
        Username = $currentUser.SamAccountName
        OUPath = $currentUser.canonicalname
        DistinguishedName = $currentUser.DistinguishedName
        LastLogonTime = $timestamp
    }

}

$result | Select-Object Name, Username, OUPath, LastLogonTime, DistinguishedName | Export-Csv -Path <#file path#> -NoTypeInformation -Force
