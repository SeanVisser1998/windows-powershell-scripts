#
# Author: Sean Visser & Mathijs Volker
# Version: 10-05-2019
#
# Group: ITV2F
# Description: Adds users to an AD group from a CSV file - Powershell Script
#

# Imports the AD module =)
Import-Module ActiveDirectory

# Specifies the parameters that need to be given in the console \(o.o)/
param(
    [string] $UserListDir
)

# Logging function :D
$logfile = "C:\Scripts\Windows\Log\SeanMathijsPS_Log_$(Get-Date -Format "yyyymmdd_hhmmtt").log"

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
            # Adds the user from the CSV to the specified group
            Add-ADGroupMember -Identity $_.Group -Member $_.User

            # Log succesfull activity :D
            log "$_.User sucessfully added to $_.Group" green

        }catch{

            # Log CSV-processing error D:
            log "An error occured whilst processing the CSV file" red
        }
    }

}catch{

    # Log CSV-loading error :(
    log "An error occured whilst loading the CSV file" red
}

