## Purpose: Install script to check if 'Process' is running, if running run Deploy-application.exe in session 1 with ServiceUI, else run it in Session 0 Silent

TODO$process_name = "Process"
$processes = @(Get-Process $process_name -ErrorAction SilentlyContinue)

if ($processes.Count -eq 0) {
    Try {
        Write-Output "$process_name is not running, we can run the installation in session 0"
        Start-Process Deploy-Application.exe -Wait -ArgumentList '-DeploymentType "Install" -DeployMode "Silent"'
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
        Write-Output "$process_name is running, we need to run the installation in session 1, ServiceUI.exe"
        Start-Process -FilePath ".\ServiceUI.exe" -ArgumentList "-process:explorer.exe", "Deploy-Application.exe", '-DeploymentType "Install"' -Wait
        $exit_code = $LASTEXITCODE
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        $ErrorMessage
        $exit_code = 1
    }
}

Write-Output "Exit Code of installation is: $exit_code"
exit $exit_code