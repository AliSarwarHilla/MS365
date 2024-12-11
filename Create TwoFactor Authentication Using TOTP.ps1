Connect-MgGraph -Scopes "UserAuthenticationMethod.ReadWrite.All", "Directory.ReadWrite.All", "Policy.ReadWrite.ConditionalAccess"

# Step 3: Define the user (replace with the actual UserPrincipalName or ID)
$userId = "user@example.com"

# Step 4: Enable Multi-Factor Authentication (MFA) for the user
Write-Host "Enabling MFA for user $userId"

# MFA is managed through Authentication Methods, so we add the MFA (Authenticator App or TOTP)
$authMethod = @{
    "@odata.type" = "#microsoft.graph.phoneAuthenticationMethod"
    "phoneNumber" = "Hilla MFA Phone Number"  # Replace with the user's phone number
    "phoneType" = "Mobile"
}

# Add the phone authentication method (used for MFA via Authenticator app)
New-MgUserAuthenticationMethod -UserId $userId -BodyParameter $authMethod

# Step 5: Check if MFA has been enabled for the user
Write-Host "Checking the authentication methods for user $userId"
$userAuthMethods = Get-MgUserAuthenticationMethod -UserId $userId
$userAuthMethods

# Step 6: Enforce Conditional Access Policy to require MFA for all users
Write-Host "Creating Conditional Access policy to enforce MFA for all users..."

New-MgConditionalAccessPolicy -DisplayName "Require MFA for all users" `
    -State "enabled" `
    -Conditions @{
        Users = @{
            Include = @("All")  # Apply the policy to all users
        }
        Applications = @{
            Include = @("All")  # Apply the policy to all apps
        }
    } `
    -GrantControls @{
        BuiltInControls = @("Mfa")  # Enforce MFA
    }

Write-Host "Conditional Access policy created and enforced."

Write-Host "MFA and TOTP (Authenticator App) setup complete for $userId."
