#Enable email forwarding to tuki@hilla.it for the user
Set-Mailbox -Identity "<user@yourdomain.com>" -ForwardingSMTPAddress "tuki@hilla.it" -DeliverToMailboxAndForward $true

#For Disabled
Set-Mailbox -Identity "<user@yourdomain.com>" -ForwardingSMTPAddress $null -DeliverToMailboxAndForward $false

#check if forward incoming email to tuki@hilla.it is active.
get-Mailbox -Identity "<user@yourdomain.com>" | Select-Object ForwardingSMTPAddress, ForwardingAddress
