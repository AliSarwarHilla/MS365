#For Enable
Connect-ExchangeOnline -UserPrincipalName $adminUsername
Set-User -Identity "example@uppista.fi" -HiddenFromAddressListsEnabled $true

#For Disabled
#Set-User -Identity "example@uppista.fi" -HiddenFromAddressListsEnabled $false

#For Check
#Get-Mailbox -Identity "example@uppista.fi" | Select-Object HiddenFromAddressListsEnabled

