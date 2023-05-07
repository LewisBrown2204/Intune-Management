## Purpose: Uninstall script to check if 'Process' is running, if running run Deploy-application.exe in session 1 with ServiceUI, else run it in Session 0 Silent
## Version: 1.0

$process_name = "Process"
$processes = @(Get-Process $process_name -ErrorAction SilentlyContinue)

if ($processes.Count -eq 0) {
    Try {
        Write-Output "$process_name is not running, we can run the Uninstallation in session 0"
        Start-Process Deploy-Application.exe -Wait -ArgumentList '-DeploymentType "Uninstall" -DeployMode "Silent"'
        $exit_code = $LASTEXITCODE
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        $ErrorMessage
        $exit_code = 1
    }
}
else {
    Try {
        Write-Output "$process_name is running, we need to run the Uninstallation in session 1, ServiceUI.exe"
        Start-Process -FilePath ".\ServiceUI.exe" -ArgumentList "-process:explorer.exe", "Deploy-Application.exe", '-DeploymentType "Uninstall"' -Wait
        $exit_code = $LASTEXITCODE
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        $ErrorMessage
        $exit_code = 1
    }
}

Write-Output "Exit Code of Uninstallation is: $exit_code"
exit $exit_code