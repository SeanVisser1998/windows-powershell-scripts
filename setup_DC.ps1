#
# Author: Sean Visser & Mathijs Volker
# Version: 10-05-2019
#
# Group: ITV2F
# Description: Sets up DC for Windows Practicum Opdracht 2 - Powershell Script
#


param(
	[string] $ADPassword
)
# AD DS Setup
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment

    #Installs AD DS Forest module
Install-ADDSForest -DomainName "isat.com" -InstallDNS -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText $ADPassword -Force)
Install-ADDSForest -DomainName "isat.internal" -CreateDNSDelegation -SafeModeAdministratorPassword (ConvertTo-SecuresString -AsPlainText $ADPassword -Force) 

    #Installs AD DS Domain controller module
Install-ADDSDomainController

    # Configures settings for DC
Rename-Computer -NewName ISAT-DC01



# DNS Setup
Install-WindowsFeature -Name DNS -IncludeManagementToolss
Add-DNSServerPrimaryZone -name isat.com -ZoneFile isat.com.DNS -DynamicUpdate NonSecureAndSecure
Add-DnsServerResourceRecordA -Name administation -ZoneName isat.com -AllowUpdateAny -IPv4Address 192.168.0.11
Add-DnsServerResourceRecordA -Name sales -ZoneName isat.com -AllowUpdateAny -IPv4Address 192.168.1.11
Add-DnsServerResourceRecordA -Name services -ZoneName isat.com -AllowUpdateAny -IPv4Address 192.168.2.11
Add-DnsServerResourceRecordA -Name rd -ZoneName isat.com -AllowUpdateAny -IPv4Address 192.168.3.11

# DHCP Setup
