
function getAUserPermissions {

    # Define the specific user
    $SpecificUser = Read-Host "Enter User email"

    Write-Host "Getting All Site collections..." -ForegroundColor Yellow

    # Get each site collection and users
    $Sites = Get-SPOSite -Limit ALL
    $allPermissions = @()

    foreach ($Site in $Sites) {
        Write-Host "Getting Users from Site collection:" $Site.Url -ForegroundColor Yellow
        $permissions = Get-SPOUser -Limit ALL -Site $Site.Url

        # Add the site URL and site name to each permission object and filter for the specific user
        foreach ($permission in $permissions) {
            if ($permission.LoginName -eq $SpecificUser) {
                $permission | Add-Member -MemberType NoteProperty -Name "SiteUrl" -Value $Site.Url
                $permission | Add-Member -MemberType NoteProperty -Name "SiteName" -Value $Site.Title
                $allPermissions += $permission
            }
        }
    }

    # Export the permissions with the site URL and site name to CSV
    $allPermissions | Export-Csv -Path "UserPermissions.csv" -NoTypeInformation
}
function getAllUsersPermissions {
    Write-Host "Getting All Site collections and users..." -ForegroundColor Yellow

    # Get each site collection and users
    $Sites = Get-SPOSite -Limit ALL
    $allPermissions = @()
    
    foreach ($Site in $Sites) {
        Write-Host "Getting Users from Site collection:" $Site.Url -ForegroundColor Yellow
        $permissions = Get-SPOUser -Limit ALL -Site $Site.Url | Select DisplayName, LoginName, IsSiteAdmin
    
        # Add the site URL to each permission object and filter LoginName
        foreach ($permission in $permissions) {
            if ($permission.LoginName -like "*@*") {
                $permission | Add-Member -MemberType NoteProperty -Name "SiteUrl" -Value $Site.Url 
                $permission | Add-Member -MemberType NoteProperty -Name "SiteName" -Value $Site.Title
                $allPermissions += $permission
            }
        }
    }
    # Export the permissions with the site URL to CSV
    $allPermissions | Export-Csv -Path "UserPermissions.csv" -NoTypeInformation
}
function getPermissionsInSite {
    Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking 
    Connect-SPOService -Url "https://gg0rsk1-admin.sharepoint.com" -ModernAuth $true -AuthenticationUrl "https://login.microsoftonline.com/organizations"

    # Prompt user for the site URL
    $SiteUrl = Read-Host -Prompt "Enter the Site URL"

    Write-Host "Getting Users from Site collection:" $SiteUrl -ForegroundColor Yellow

    # Get users from the specified site
    $permissions = Get-SPOUser -Limit ALL -Site $SiteUrl | Select DisplayName, LoginName, IsSiteAdmin
    $allPermissions = @()

    # Add the site URL and site name to each permission object and filter LoginName
    foreach ($permission in $permissions) {
        if ($permission.LoginName -like "*@*") {
            $permission | Add-Member -MemberType NoteProperty -Name "SiteUrl" -Value $SiteUrl
            $permission | Add-Member -MemberType NoteProperty -Name "SiteName" -Value (Get-SPOSite -Identity $SiteUrl).Title
            $allPermissions += $permission
        }
    }

    # Export the permissions with the site URL and site name to CSV
    $allPermissions | Export-Csv -Path "UserPermissions.csv" -NoTypeInformation

}
function getPermissionOfUserInSite {
    $SiteUrl = Read-Host -Prompt "Enter the Site URL"
    $SpecificUser = Read-Host -Prompt "Enter the specific user's LoginName"

    Write-Host "Getting Users from Site collection:" $SiteUrl -ForegroundColor Yellow

    # Get users from the specified site
    $permissions = Get-SPOUser -Limit ALL -Site $SiteUrl | Select DisplayName, LoginName, IsSiteAdmin
    $allPermissions = @()

    # Add the site URL and site name to each permission object and filter for the specific user
    foreach ($permission in $permissions) {
        if ($permission.LoginName -eq $SpecificUser) {
            $permission | Add-Member -MemberType NoteProperty -Name "SiteUrl" -Value $SiteUrl
            $permission | Add-Member -MemberType NoteProperty -Name "SiteName" -Value (Get-SPOSite -Identity $SiteUrl).Title
            $allPermissions += $permission
        }
    }

    # Export the permissions with the site URL and site name to CSV
    $allPermissions | Export-Csv -Path "UserPermissions.csv" -NoTypeInformation
}
function Show-Menu {
    Clear-Host
    Write-Output "====================="
    Write-Output " PowerShell Menu"
    Write-Output "====================="
    Write-Output "1: Get A User's Permissions"
    Write-Output "2: Get All Users' Permissions in All Sites "
    Write-Output "3: Get All Users' Permissions in Specific Site "
    Write-Output "4: Get  User's Permissions in Specific Site "
    Write-Output "0: Exit"
    Write-Output "====================="
}

# Main script
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking 
Connect-SPOService -Url "https://gg0rsk1-admin.sharepoint.com" -ModernAuth $true -AuthenticationUrl "https://login.microsoftonline.com/organizations"
do {
    Show-Menu
    $choice = Read-Host "Enter your choice"

    switch ($choice) {
        1 { getAUserPermissions }
        2 { getAllUsersPermissions }
        3 { getPermissionsInSite }
        4 { getPermissionOfUserInSite}
        default { Write-Output "Invalid choice, please try again." }
    }

    if ($choice -ne 0) {
        Write-Output "`nPress Enter to continue..."
        Read-Host
    }
} while ($choice -ne 0)