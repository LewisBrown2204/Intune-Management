# Vars
. ".vscode\Global.ps1"

# Copy Resources
Copy-Item -Path ".vscode\$LogonCommand" -Destination "$env:ProgramData\win32app\" -Recurse -Force -Verbose -ErrorAction Ignore

# Prepare Sandbox
@"
<Configuration>
<Networking>Enabled</Networking>
<MappedFolders>
    <MappedFolder>
    <HostFolder>$env:ProgramData\win32app</HostFolder>
    <SandboxFolder>$WDADesktop</SandboxFolder>
    <ReadOnly>true</ReadOnly>
    </MappedFolder>
</MappedFolders>
<LogonCommand>
    <Command>powershell -executionpolicy unrestricted -command "Start-Process powershell -ArgumentList ""-nologo -file $WDADesktop\$LogonCommand"""</Command>
</LogonCommand>
</Configuration>
"@ | Out-File "$env:ProgramData\win32app\$Application.wsb"

# Execute Sandbox
Start-Process explorer -ArgumentList "$env:ProgramData\win32app\$Application.wsb" -Verbose