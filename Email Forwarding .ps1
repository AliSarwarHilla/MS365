

#For Enabled
Set-Mailbox -Identity "<user@yourdomain.com>" -ForwardingSMTPAddress "<externalmail>" -DeliverToMailboxAndForward $true

#For Disabled
Set-Mailbox -Identity "<user@yourdomain.com>" -ForwardingSMTPAddress $null -DeliverToMailboxAndForward $false

#For Check
get-Mailbox -Identity "<user@yourdomain.com>" | Select-Object ForwardingSMTPAddress, ForwardingAddress