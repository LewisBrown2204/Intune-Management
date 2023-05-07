# Vars
[string]$Desktop = [Environment]::GetFolderPath('DesktopDirectory')
[string]$WDADesktop = "C:\Users\WDAGUtilityAccount\Desktop"
[string]$Application = "$(& git branch --show-current)"
[string]$Cache = "$env:ProgramData\win32app\$Application"
[string]$LogonCommand = "LogonCommand.ps1"

# Cache resources
Remove-Item -Path "$Cache" -Recurse -Force -ErrorAction Ignore
Copy-Item -Path "App" -Destination "$Cache" -Recurse -Force -Verbose -ErrorAction Ignore
explorer "$Cache"