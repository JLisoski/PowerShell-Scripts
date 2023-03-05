#isEnabled script that checks if an ADAccount is disabled or not

#Clear Error
$Error.Clear()

$users = Import-Csv <#file path#>

$result = foreach($user in $users){

    #Grab ADUSer
    $currentUser = Get-ADUser -Server <#Domain#> -Properties * -Identity $user.DistinguishedName

    #For Debugging
    #Write-Host $currentUser.Name

    New-Object psobject -Property @{
        Name = $currentUser.Name
        Username = $currentUser.SamAccountName
        DistinguishedName = $currentUser.DistinguishedName
        isEnabled = $currentUser.Enabled
    }

}

$result | Select-Object Name, Username, isEnabled, DistinguishedName | Export-Csv -Path <#file path#> -NoTypeInformation -Force
