# JV-EntraIDGetPrivilegedEntApps

A great, fast and easy PowerShell script to get all Entra ID Enterprise Applications and their privileges developed by Justin Verstijnen.

---

## Overview and Features

**JV-EntraIDGetPrivilegedEntApps** is a simple PowerShell script that does the following:
- Query all Enterprise Applications
- Query all privileges in those Enterprise Applications
- Query if a secret or certificate is linked to a Enterprise Application
- Pre-formatted for use with Excel
- Applications without Application or Delegated permissions will be skipped and not in the CSV file

---

## Requirements

- **Microsoft Graph Powershell module**, you can download this by using:

```
Install-Module Microsoft.Graph -Scope CurrentUser -Repository PSGallery -Force
```

## How to run?

Download the script and save it to your favorite location. Then open Powershell.

Copy or navigate to the path of the script and type .\ and then the script name to run it.

If Powershell says something about not running because of the execution policy, you can temporarily disable this with:

```
Set-ExecutionPolicy Unrestricted -Scope Process
```

Then run the script:

```
.\JV-EntraIDGetPrivilegedEntApps.ps1
```
