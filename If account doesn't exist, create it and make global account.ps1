Connect-MgGraph -Scopes "User.ReadWrite.All", "Directory.ReadWrite.All"

# Specify the UserPrincipalName (email address) of the user
$userPrincipalName = "newuser@yourdomain.com"
$userDisplayName = "New User"
$userGivenName = "New"
$userSurname = "User"
$userPassword = "InitialPassword123" # Strong password meeting requirements

# Check if the user exists
try {
    $user = Get-MgUser -UserId $userPrincipalName -ErrorAction Stop
    $userExists = $true
} catch {
    $userExists = $false
}

if ($userExists) {
    Write-Output "User $userPrincipalName already exists."
} else {
    # Create the user account
    $user = New-MgUser -AccountEnabled $true `
                       -DisplayName $userDisplayName `
                       -GivenName $userGivenName `
                       -Surname $userSurname `
                       -UserPrincipalName $userPrincipalName `
                       -PasswordProfile @{forceChangePasswordNextSignIn = $true; password = $userPassword}

    Write-Output "User $userPrincipalName created successfully."
}

# Hide the user from address lists
Update-MgUser -UserId $user.Id -AdditionalProperties @{"hideFromAddressListsEnabled" = $true}
Write-Output "User $userPrincipalName is now hidden from address lists."

# Assign the user to the Global Administrator role
# Get the role definition ID for Global Administrator
$roleDefinition = Get-MgDirectoryRole -Filter "displayName eq 'Global Administrator'"

# Check if the role definition exists
if ($roleDefinition) {
    # Add the user to the Global Administrator role
    New-MgDirectoryRoleMember -DirectoryRoleId $roleDefinition.Id -Id $user.Id
    Write-Output "User $userPrincipalName has been assigned the Global Administrator role."
} else {
    Write-Output "Global Administrator role not found."
}


