Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking 
Connect-SPOService -Url "https://gg0rsk1-admin.sharepoint.com" -ModernAuth $true -AuthenticationUrl "https://login.microsoftonline.com/organizations"

# Get all users and their permissions
$siteUrl = "https://YourDomainName.sharepoint.com/sites/IT"
$users = Get-SPOUser -Site $siteUrl
$permissions = @()

foreach ($user in $users) {
    $userPermissions = Get-SPOUserEffectivePermissions -Site $siteUrl -LoginName $user.LoginName
    foreach ($permission in $userPermissions) {
        $permissions += [PSCustomObject]@{
            UserName = $user.LoginName
            Permission = $permission
        }
    }
}

# Export to CSV
$permissions | Export-Csv -Path "ExportedFile.csv" -NoTypeInformation

Write-Host "Permissions exported to "
