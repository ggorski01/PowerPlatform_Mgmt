function GrantAdminAllSites {
    # Prompt user for the specific user's LoginName
    $SpecificUser = Read-Host -Prompt "Enter the specific user's LoginName"

    Write-Host "Getting All Site collections..." -ForegroundColor Yellow

    # Get all site collections
    $Sites = Get-SPOSite -Limit ALL

    foreach ($Site in $Sites) {
        Write-Host "Granting Site Collection Admin to user on site:" $Site.Url -ForegroundColor Yellow
        Set-SPOUser -Site $Site.Url -LoginName $SpecificUser -IsSiteCollectionAdmin $true
    }

    Write-Host "Site Collection Admin permissions granted to user: $SpecificUser" -ForegroundColor Green
}
function GrantAdminToSite {
    # Prompt user for the specific user's LoginName and the site URL
    $SpecificUser = Read-Host -Prompt "Enter the specific user's LoginName"
    $SiteUrl = Read-Host -Prompt "Enter the Site URL"

    Write-Host "Granting Site Collection Admin to user on site:" $SiteUrl -ForegroundColor Yellow

    # Grant site collection admin permissions to the specific user on the specified site
    Set-SPOUser -Site $SiteUrl -LoginName $SpecificUser -IsSiteCollectionAdmin $true

    Write-Host "Site Collection Admin permissions granted to user: $SpecificUser on site: $SiteUrl" -ForegroundColor Green
}
function RevokeAdminAllSites {
    # Prompt user for the specific user's LoginName
    $SpecificUser = Read-Host -Prompt "Enter the specific user's LoginName"

    Write-Host "Getting All Site collections..." -ForegroundColor Yellow

    # Get all site collections
    $Sites = Get-SPOSite -Limit ALL

    foreach ($Site in $Sites) {
        Write-Host "Granting Site Collection Admin to user on site:" $Site.Url -ForegroundColor Yellow
        Set-SPOUser -Site $Site.Url -LoginName $SpecificUser -IsSiteCollectionAdmin $false
    }

    Write-Host "Site Collection Admin permissions granted to user: $SpecificUser" -ForegroundColor Green
}
function RevokeAdminToSite {
    # Prompt user for the specific user's LoginName and the site URL
    $SpecificUser = Read-Host -Prompt "Enter the specific user's LoginName"
    $SiteUrl = Read-Host -Prompt "Enter the Site URL"

    Write-Host "Granting Site Collection Admin to user on site:" $SiteUrl -ForegroundColor Yellow

    # Grant site collection admin permissions to the specific user on the specified site
    Set-SPOUser -Site $SiteUrl -LoginName $SpecificUser -IsSiteCollectionAdmin $false

    Write-Host "Site Collection Admin permissions granted to user: $SpecificUser on site: $SiteUrl" -ForegroundColor Green
}
function Show-Menu {
    Clear-Host
    Write-Output "====================="
    Write-Output " PowerShell Menu"
    Write-Output "====================="
    Write-Output "1: Grant A User Site Admin to All Site Collections."
    Write-Output "2: Grant A User Site Admin to Specic Site Collection."
    Write-Output "3: Revoke A User Site Admin to All Site Collections."
    Write-Output "4: Revoke A User Site Admin to Specic Site Collection."
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
        1 { GrantAdminAllSites }
        2 { GrantAdminToSite }
        3 { RevokeAdminAllSites }
        4 { RevokeAdminToSite }
        default { Write-Output "Invalid choice, please try again." }
    }

    if ($choice -ne 0) {
        Write-Output "`nPress Enter to continue..."
        Read-Host
    }
} while ($choice -ne 0)