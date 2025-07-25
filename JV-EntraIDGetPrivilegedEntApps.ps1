# Justin Verstijnen Entra ID Get Privileged Users-script
# Github page: https://github.com/JustinVerstijnen/JV-EntraIDGetPrivilegedEntApps
# Let's start!
Write-Host "Script made by..." -ForegroundColor DarkCyan
Write-Host "     _           _   _        __     __            _   _  _                  
    | |_   _ ___| |_(_)_ __   \ \   / /__ _ __ ___| |_(_)(_)_ __   ___ _ __  
 _  | | | | / __| __| | '_ \   \ \ / / _ \ '__/ __| __| || | '_ \ / _ \ '_ \ 
| |_| | |_| \__ \ |_| | | | |   \ V /  __/ |  \__ \ |_| || | | | |  __/ | | |
 \___/ \__,_|___/\__|_|_| |_|    \_/ \___|_|  |___/\__|_|/ |_| |_|\___|_| |_|
                                                       |__/                  " -ForegroundColor DarkCyan

# === PARAMETERS ===
$exportfile = "JV-EntraIDGetPrivilegedEntApps_report.csv"

# Step 1: Sign in
Write-Host -Foreground Green "Let's sign you in to Microsoft Entra ID:"
Connect-MgGraph -Scopes "Application.Read.All", "Directory.Read.All" -NoWelcome


# Step 2: Getting applications
Write-Host -Foreground Yellow "Querying all applications..."
$applications = Get-MgApplication -All
$servicePrincipals = Get-MgServicePrincipal -All

# Step 3: Formatting data
Write-Host -Foreground Yellow "Formatting data..."
$spLookup = @{}
$permissionsLookup = @{}

foreach ($sp in $servicePrincipals) {
    if ($sp.AppId) {
        $spLookup[$sp.AppId] = $sp.DisplayName

        foreach ($res in @($sp.Oauth2PermissionScopes + $sp.AppRoles)) {
            $permissionsLookup["$($sp.AppId)|$($res.Id)"] = $res.Value
        }
    }
}

# Step 4: Saving results in array
Write-Host -Foreground Yellow "Converting information to CSV..."
$appDetails = @()

foreach ($app in $applications) {
    $hasSecret = ($app.PasswordCredentials | Where-Object { $_.EndDateTime -gt (Get-Date) }).Count -gt 0
    $hasCert = ($app.KeyCredentials | Where-Object { $_.EndDateTime -gt (Get-Date) }).Count -gt 0

    foreach ($resourceAccess in $app.RequiredResourceAccess) {
        $resourceAppId = $resourceAccess.ResourceAppId

        foreach ($access in $resourceAccess.ResourceAccess) {
            $permType = if ($access.Type -eq "Role") { "Application" } else { "Delegated" }
            $permKey = "$resourceAppId|$($access.Id)"
            $permName = $permissionsLookup[$permKey]
            # Here is the format of the CSV file
            $appDetails += [PSCustomObject]@{
                ApplicationId     = $app.AppId
                DisplayName       = $app.DisplayName
                PermissionType    = $permType
                PermissionName    = $permName
                PermissionId      = $access.Id
                HasClientSecret   = $hasSecret
                HasCertificate    = $hasCert
            }
        }
    }
}

# Step 5: Exporting
$appDetails | Export-Csv -Path $exportfile -NoTypeInformation -Encoding UTF8 -Delimiter ";"
Write-Host "Export finished: $exportfile" -ForegroundColor Green
Write-Host -Foreground Green "If no further errors occured, the script has been succesfully executed. Go check out your file. Thank you for using my script!"
Start-Sleep -Seconds 3
