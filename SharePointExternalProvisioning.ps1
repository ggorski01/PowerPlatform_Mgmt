
#If you don't have the module install
#Run the Install, powershell script works on PowerShell 5 or less.
# Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Scope CurrentUser -Force

Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking 
Connect-SPOService -Url "https://gg0rsk1-admin.sharepoint.com" -ModernAuth $true -AuthenticationUrl "https://login.microsoftonline.com/organizations"

Function New-ExtSite{
    Clear-Host
    Write-Host "To avoid creating duplicates, please make sure you confirmed no existing site for Vendor/Company."
    $vendorName= Read-Host -Prompt "Enter the vendor/company name"
    $siteURL = "https://gg0rsk1.sharepoint.com/sites/"+$vendorName+"-EXTERNAL"
    $siteName= $vendorName+"-EXTERNAL"


    Write-Host "Creating External SharePoint site.... "
    Write-Host "URL: " $siteURL 
    Write-Host "Site Name: " $siteName

    #Create a Communication Template New Site
    New-SPOSite -Url $siteURL -Owner "ggorski1@gg0rsk1.onmicrosoft.com" -StorageQuota 1024 -Title $siteName -Template "SITEPAGEPUBLISHING#0"

    #Change External Sharing Settings to
    Write-Host "Changing External SharePoint site sharing settings.... "
    Set-SPOSite -Identity $siteURL -SharingCapability ExternalUserSharingOnly


    #Change Permissions to Default Members Group

    $MembersGroup = $siteName+" Members"
    Write-Host "Changing " $MembersGroup " group permissions to Edit only..."
    New-SPOSiteGroup -Site $siteURL -Group $MembersGroup -PermissionLevels "Contribute"
    Remove-SPOSiteGroup -Site $siteURL -Identity "Site Members"

    #Create New Members-CUI
    $MembersCUI = $siteName+" Members-CUI"
    Write-Host "Creating" $MembersCUI " group and setting permissions to Edit only..."

    New-SPOSiteGroup -Site $siteURL -Group $MembersCUI -PermissionLevels "Contribute"


    Write-Host $SiteURL " provisioned with success."
    Start-Process $SiteURL"/_layouts/15/user.aspx"
}

Function Find-ExtSite{
    Clear-Host
    $siteName= Read-Host -Prompt "Enter the vendor/company name"

    # Get all sites and filter by siteName
    $sites = Get-SPOSite -Limit All | Where-Object { $_.Url -like "*$siteName*" }
    # Display the filtered sites in a table format
    Write-Host "Site URL".PadRight(50) "Title".PadRight(30) "Template"
    Write-Host ("-" * 100)
    $sites | ForEach-Object {
        Write-Host $_.Url.PadRight(50) $_.Title.PadRight(30) $_.Template
    }
}

function Show-Menu {
    Clear-Host
    Write-Output "====================="
    Write-Output " PowerShell Menu"
    Write-Output "====================="
    Write-Output "1: Create New External Site"
    Write-Output "2: Find External Site"
    Write-Output "0: Exit"
    Write-Output "====================="
}

# Main script
do {
    Show-Menu
    $choice = Read-Host "Enter your choice"

    switch ($choice) {
        1 { New-ExtSite }
        2 { Find-ExtSite}
        default { Write-Output "Invalid choice, please try again." }
    }

    if ($choice -ne 0) {
        Write-Output "`nPress Enter to continue..."
        Read-Host
    }
} while ($choice -ne 0)