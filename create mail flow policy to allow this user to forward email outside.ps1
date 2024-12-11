#Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser
#Connect-ExchangeOnline -UserPrincipalName "admin@example.com" -ShowProgress $true

$userEmail = "user@example.com"  # Replace with the user's email address
$ruleName = "Allow External Forwarding for Specific User"

New-TransportRule -Name $ruleName `
    -From $userEmail `
    -SentToScope NotInOrganization `
    -SetHeaderName "X-MS-Exchange-Organization-BypassForwardingRestrictions" `
    -SetHeaderValue "true" `
    -StopRuleProcessing $true
