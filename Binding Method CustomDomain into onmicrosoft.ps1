function Convert-UserAccounts {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, HelpMessage="Source domain to convert")]
        [string]$SourceDomain = "uppista.fi",  # Source domain to search for the users
        
        [Parameter(Mandatory=$false, HelpMessage="Target Microsoft 365 domain")]
        [string]$TargetDomain = "uppistafi.onmicrosoft.com"  # Target domain (must be a valid domain)
    )
    
    #  using the right modules
    try {
        Write-Host "Importing required Microsoft.Graph modules..."
        Import-Module Microsoft.Graph.Users -ErrorAction Stop
        Import-Module Microsoft.Graph.Identity.DirectoryManagement -ErrorAction Stop
    }
    catch {
        Write-Error "Required PowerShell modules are not installed. Please run:`nInstall-Module Microsoft.Graph.Users -Force`nInstall-Module Microsoft.Graph.Identity.DirectoryManagement -Force"
        return
    }
    
    try {
        # Connect to Microsoft Graph with appropriate permissions
        Write-Host "Connecting to Microsoft Graph..."
        Connect-MgGraph -Scopes "User.ReadWrite.All", "Directory.ReadWrite.All"
        
        # Get all users with the source domain
        Write-Host "Fetching users with the source domain ($SourceDomain)..."
        $users = Get-MgUser -All | Where-Object { 
            $_.UserPrincipalName -like "*@$SourceDomain" 
        }
        
        if ($users.Count -eq 0) {
            Write-Host "No users found with the domain @$SourceDomain"
            return
        }
        
        # Process each user
        foreach ($user in $users) {
            # Generate new user principal name by replacing the source domain with the target domain
            $oldUpn = $user.UserPrincipalName
            $newUpn = $oldUpn -replace "@$SourceDomain", "@$TargetDomain"
            
            try {
                # Update user principal name
                Write-Host "Updating user: $($user.DisplayName)"
                Update-MgUser -UserId $user.Id -UserPrincipalName $newUpn
                
                Write-Host "Converted user account:"
                Write-Host "  Display Name: $($user.DisplayName)"
                Write-Host "  Old UPN: $oldUpn"
                Write-Host "  New UPN: $newUpn"
            }
            catch {
                Write-Host "Failed to convert user $($user.DisplayName): $($_.Exception.Message)"
            }
        }
    }
    catch {
        Write-Host "An error occurred during the conversion process: $($_.Exception.Message)"
    }
    finally {
        # Disconnect from Microsoft Graph
        Write-Host "Disconnecting from Microsoft Graph..."
        Disconnect-MgGraph
    }
}

# Execute the function
Convert-UserAccounts
