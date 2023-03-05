<#
.SYNOPSIS
Adds an entry to a given servers host file or removes a given entry from the servers host file. 
.DESCRIPTION
Script will add a single entry to the servers host file, or it will remove ALL insances of a given host entry from the host file. In order to remove, you will need to add a regex to the variable $Pattern, on line 62. In the form of "'\d.*<hostname>.*'"
#>

#Server Array, hard coded 
$Script:Servers = <#server list#> 

#For Debugging
#$Servers

#Flags for Add or Remove, set to true 
$Script:Add = $false
$Script:Remove = $true

#Record to either add or remove from the host file 
$Script:record= "192.168.56.253  Snickerdoodles  #This line is for testing"

#String to reset a hostfile to Microsoft's Default Host File 
<#
$Script:record = "# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
#      102.54.94.97     rhino.acme.com          # source server
#       38.25.63.10     x.acme.com              # x client host

# localhost name resolution is handled within DNS itself.
#	127.0.0.1       localhost
#	::1             localhost"
#>

#Check if Server Array is empty, and if it is return out of the script
If(($Script:Servers | Measure-Object).Count -lt 1){
    Write-Warning "This shouldnt ever be empty since you are manually entering the names..."
    return
}

#Clear Error variable 
$Error.Clear()

#Call Inovke-Command on the given servers 
$Results = Invoke-Command -ErrorAction SilentlyContinue -ComputerName $Script:Servers -Credential $creds -ScriptBlock{

    #For Debugging:
    #Write-Host "Connected to $ENV:COMPUTERNAME"

    #Regex Pattern to match to, hard coded  
    $Pattern = '\d.*Snickerdoodles.*'

    #Grab host file content
    $hostFiles = Get-Content $env:SystemRoot\System32\Drivers\etc\hosts

    #Array to hold altered host file content after removing 
    $newHostFiles = @()

    #For Debugging
    #Write-Host "Adding is $Using:Add"
    #Write-Host "Removing is $Using:Remove"

    if($Using:Add){
        #For Debugging
        Write-Host "Addding $Using:record to hostfile"

        #Add to host file content
        $hostFiles += $Using:record

        #Set as new host file 
        Set-Content -Path $env:SystemRoot\System32\Drivers\etc\hosts -Value $hostFiles -Force

    }elseif($Using:Remove){
        #For Debugging
        Write-Host "Removing $Using:record from hostfile"

        #Check each line of text against the regex pattern
        $hostFiles| ForEach-Object -Process {
            #Grab the substring that ends at the #, if now hashtag set to $_ 
            if($_.indexOf("#") -eq -1){
                $grabbedLine = $_
            }else{
                $grabbedLine = $_.substring(0, $_.indexOf("#"))
            }

            #For Debugging 
            #Write-Host "Record to match is $Using:record"

            #If line matches the regex pattern, output the information
            If($grabbedLine -match $Pattern){
                #For Debugging
                #Write-Host "$env:COMPUTERNAME, $($Matches.IP), $($Matches.Host)"
                #Write-Host "Inside If Matches block..."

                #Replace with blank line
                $hostFiles.Remove($_)
            }else{
                $newHostFiles += $_
            }
        }

        #Reset hostFile with new host file array
        $hostFiles = $newHostFiles

        #Set as new host file
        Set-Content -Path $env:SystemRoot\System32\Drivers\etc\hosts -Value $hostFiles -Force

    }else{
        Write-Host "Neither Add or Remove were chosen! This is all the script does"
    }

    #ForDebugging 
    #Write-Warning "SystemRoot is... $env:SystemRoot"

    #Has to be here to see values in $Results through the PowerShell Terminal. 
    $hostFiles

    #For Debugging
    #Write-Host "Disconnecting from $ENV:COMPUTERNAME"
}
