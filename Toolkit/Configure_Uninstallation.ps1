## Purpose: Install script to check if 'Process' is running, if running run Deploy-application.exe in session 1 with ServiceUI, else run it in Session 0 Silent
## Version: 1.0

$Processes = @(Get-WmiObject -Query "select * FROM Win32_process WHERE name='Process.exe'" -ErrorAction SilentlyContinue)
if ($Processes.Count -eq 0) {
    Try {
        Write-Output "Process is not running, we can run the installation in session 0"
        Start-Process Deploy-Application.exe -Wait -ArgumentList '-DeploymentType "Uninstall" -DeployMode "Silent"'
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        $ErrorMessage
    }
}
else {
    Try {
        Write-Output "Process is running, we need to run the uninstallation in session 1, ServiceUI.exe"
        .\ServiceUI.exe -process:explorer.exe Deploy-Application.exe -DeploymentType "Uninstall"
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        $ErrorMessage
    }

}

Write-Output "Exit Code of installation is: $LASTEXITCODE"
exit $LASTEXITCODE