## Configure_Uninstallation.ps1
## Purpose: Uninstall script to check if 'Process(es)' is running, if running run Deploy-application.exe in session 1 with ServiceUI, else run it in Session 0 Silent
## TODO - Check if 'Process(es)' is running

# TODO Application name
$application = ""
$logFile = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\$application Uninstallation_Configuration.log"

# TODO Add the process names
$process_names = "", ""
$processes = @(Get-Process -Name $process_names -ErrorAction SilentlyContinue)

# Function to write log messages to the file
function Write-Log([string]$message) {
    $timestamp = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
    $logEntry = "$timestamp - $message"
    Add-Content -Path $logFile -Value $logEntry
}

#region Script Execution
if ($processes.Count -eq 0) {
    Try {
        $message = "$process_names are not running, we can run the Uninstallation in session 0"        
        Write-Log $message
        Start-Process -FilePath .\Deploy-Application.exe -Wait -ArgumentList '-DeploymentType "Uninstall" -DeployMode "Silent"'
        $exit_code = $LASTEXITCODE
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Log $ErrorMessage
        $exit_code = 1
    }
}
else {
    Try {
        $message = "$process_names are running, we need to run the Uninstallation in session 1 using ServiceUI.exe"        
        Write-Log $message
        .\ServiceUI.exe -process:explorer.exe Deploy-Application.exe -DeploymentType "Uninstall"
        $exit_code = $LASTEXITCODE
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Log $ErrorMessage
        $exit_code = 1
    }
}
#endregion

# Write log message
Write-Log $message
exit $exit_code