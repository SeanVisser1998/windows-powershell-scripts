#
# Author: Sean Visser & Mathijs Volker
# Version: 10-05-2019
#
# Group: ITV2F
# Description: Sets up DC for Windows Practicum Opdracht 2 - Powershell Script
#


param(
	[string] $DomainName
	[string] $ADPassword
)
# AD DS Setup
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment

    #Installs AD DS Forest module
Install-ADDSForest -DomainName $DomainName -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText $ADPassword -Force)

    #Installs AD DS Domain controller module
Install-ADDSDomainController

    # Configures settings for DC
Rename-Computer -NewName ISAT-DC01



# DNS Setup


# DHCP Setup
