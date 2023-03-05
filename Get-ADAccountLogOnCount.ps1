#Clear Error
$Error.Clear()

#Define DC's, have to manually check DC's that can not be powershell-ed into
#$fnbmDC = (get-adcomputer -SearchBase <Domain OU where DCs located> -filter {Enabled -eq $True} -server <Domain>).dnshostname

Invoke-Command -ComputerName <#List of domain DC's#> -Credential $creds -ScriptBlock{

    $currUser = Get-ADUser -Properties logonCount -Identity <#ADUser#>


    #Check if logon count is null and set to 0 
    if($currUser.logonCount -eq $null){
        $currUser.logonCount = 0
    }

    #Print user name and log on count for the DC
    Write-Host $currUser.Name "has logged on" $currUser.logonCount "in" $ENV:COMPUTERNAME 

}
