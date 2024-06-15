#Parameters
Import-Module PnP.PowerShell
$SiteURL = "https://###-admin.sharepoint.com/"
$TodayDate = Get-Date -Format "MM-dd-yyyy"
$CSVPath = "AllSiteOwners - "+$TodayDate+".csv"
  
#Connect to Admin Center Site
Connect-PnPOnline -Url $SiteURL -Interactive
   
#Get All Site collections
$SiteCollections = Get-PnPTenantSite
$SiteOwners = @()
$SiteCollections
#Loop through each site collection
ForEach($Site in $SiteCollections)
{
    Write-Host $Site.Url
    If($Site.Template -like 'GROUP*')
    {
        #Get Group Owners
        $Owners = (Get-PnPMicrosoft365GroupOwners -Identity $Site.GroupId | Select -ExpandProperty Email) -join "; "
        
    }
    Else
    {
        #Get Site Owner
        $Owners = $Site.Owner
        
    }
     #Collect Data
    $SiteOwners += New-Object PSObject -Property @{
    'Site Title' = $Site.Title
    'Owner(s)' = $Owners
    'URL' = $Site.Url
    'GroupID'= $Site.GroupId
    'Site Template'= $Site.Template
    } 
}
#Get Site Owners
#$SiteOwners
  
#Export Site Owners report to CSV
$SiteOwners | Export-Csv -path $CSVPath -NoTypeInformation
