#######
#GENERAL SCRIPT#

Get-MgSubscribedSku | Select SkuId, SkuPartNumber, SkuCategory
Set-MgUserLicense -UserId $UserPrincipalName -AddLicenses $LicenseAssignment.AddLicenses -RemoveLicenses $LicenseAssignment.RemoveLicenses



##########################################
#for single and multiple users 

# Import the Microsoft Graph module
Import-Module Microsoft.Graph

# Define license assignment details
$AddLicenses = @("license-sku-id")   # Replace with actual SkuId(s) you want to assign
$RemoveLicenses = @("license-sku-id") # Replace with actual SkuId(s) you want to remove

# Function to assign/remove licenses for a user
function Assign-RemoveLicenses {
    param (
        [string[]]$Users
    )
    foreach ($UserPrincipalName in $Users) {
        Set-MgUserLicense -UserId $UserPrincipalName -AddLicenses $AddLicenses -RemoveLicenses $RemoveLicenses
        Write-Host "Licenses assigned/removed for user $UserPrincipalName"
    }
}

# Ask if processing a single user or multiple users
$Choice = Read-Host "Do you want to process a single user or multiple users? (single/multiple)"

if ($Choice -eq "single") {
    # For a single user, prompt for UserPrincipalName (email)
    $UserPrincipalName = Read-Host "Enter the UserPrincipalName (email address) of the user"
    Assign-RemoveLicenses -Users @($UserPrincipalName)
}
elseif ($Choice -eq "multiple") {
    # For multiple users, ask if loading from CSV or manual input
    $UserSource = Read-Host "Do you want to input user emails manually or load from a CSV? (manual/csv)"
    
    if ($UserSource -eq "manual") {
        $Users = @()
        $continue = $true
        while ($continue) {
            $UserPrincipalName = Read-Host "Enter a UserPrincipalName (email address), or type 'done' to finish"
            if ($UserPrincipalName -eq "done") {
                $continue = $false
            } else {
                $Users += $UserPrincipalName
            }
        }
        Assign-RemoveLicenses -Users $Users
    }
    elseif ($UserSource -eq "csv") {
        $CsvPath = Read-Host "Enter the full path of the CSV file"
        if (Test-Path $CsvPath) {
            $Users = Import-Csv -Path $CsvPath | Select-Object -ExpandProperty UserPrincipalName
            Assign-RemoveLicenses -Users $Users
        } else {
            Write-Host "The CSV file does not exist. Please check the path and try again."
        }
    }
    else {
        Write-Host "Invalid option. Please type 'manual' or 'csv'."
    }
}
else {
    Write-Host "Invalid choice. Please type 'single' or 'multiple'."
}

Write-Host "Script execution completed."




#######################################################################
#for single user only
# Import required module
Import-Module Microsoft.Graph

# Variables
$UserPrincipalName = "user@example.com"  # Specify the UserPrincipalName of the user
$LicenseAssignment = New-Object -TypeName PSObject -Property @{
    AddLicenses = @("license-sku-id")  # Replace with the actual SkuId(s) you want to assign
    RemoveLicenses = @("license-sku-id")  # Replace with the actual SkuId(s) you want to remove
}

# Assign and Remove Licenses for the User
Set-MgUserLicense -UserId $UserPrincipalName -AddLicenses $LicenseAssignment.AddLicenses -RemoveLicenses $LicenseAssignment.RemoveLicenses

Write-Host "Licenses assigned and removed successfully for user $UserPrincipalName"





#####################################################################################
#for multiple users only
# Import required module
Import-Module Microsoft.Graph

# Variables
$LicenseAssignment = New-Object -TypeName PSObject -Property @{
    AddLicenses = @("license-sku-id")  # Replace with the actual SkuId(s) you want to assign
    RemoveLicenses = @("license-sku-id")  # Replace with the actual SkuId(s) you want to remove
}

# Option 1: Manually specify a list of UserPrincipalNames (emails)
$Users = @("user1@example.com", "user2@example.com", "user3@example.com")

# Option 2: Or, import users from a CSV file (if available)
# $Users = Import-Csv -Path "C:\path\to\users.csv" | Select-Object -ExpandProperty UserPrincipalName

# Iterate through each user and assign/remove licenses
foreach ($UserPrincipalName in $Users) {
    Set-MgUserLicense -UserId $UserPrincipalName -AddLicenses $LicenseAssignment.AddLicenses -RemoveLicenses $LicenseAssignment.RemoveLicenses
    Write-Host "Licenses assigned and removed successfully for user $UserPrincipalName"
}

