#
# Author: Sean Visser 
# Version: 10-05-2020
#
# Group: ITV2G
# Description: Adds users to an AD group from a CSV file - Powershell Script
#
# CSV: voornaam, achternaam, gebruikersnaam, defaultwachtwoord, group, OU, DC
# Imports the AD module =)
Import-Module ActiveDirectory

# Specifies the parameters that need to be given in the console \(o.o)/
param(
    [string] $UserListDir
)

# Logging function :D
$logfile = "C:\Scripts\Windows\Log\SeanPS_Log_$(Get-Date -Format "yyyymmdd_hhmmtt").log"

function log($message, $color){

    # If $color is not set, set it to white
    if ($color -eq $null) {
        $color = "white"
    }

    # Outputs the logged message to the console
    Write-Host $message -ForegroundColor $color

    # Appends the message to the logfile
    $message | Out-File -FilePath $logfile -Append
}

# Try-catch-block error handling ;)
try{

    #Reads the specified CSV file
    Import-Csv $UserListDir | % {

        try{
            #Makes new user object
            New-ADUser -Name $_.User -GivenName $_.$User -SamAccountName $_.Gebruikersnaam -AccountPassword (ConvertTo-SecureString "Welkom01" -AsPlainText -Force) -Path "OU=$_.OU,DC=$_.DC" -PassThru : Enable-ADAccount 
        
            # Adds the user from the CSV to the specified group
            Add-ADGroupMember -Identity $_.Group -Member $_.Gebruikersnaam

            # Log succesfull activity :D
            log "$_.Gebruikersnaam sucessfully added to $_.Group" green

        }catch{

            # Log CSV-processing error D:
            log "An error occured whilst processing the CSV file" red
        }
    }

}catch{

    # Log CSV-loading error :(
    log "An error occured whilst loading the CSV file" red
}

