## Configure_Installation.ps1
## Purpose: Install script to check if 'Process(es)' is running, if running run Deploy-application.exe in session 1 with ServiceUI, else run it in Session 0 Silent
## TODO - Check if 'Process(es)' is running

$application = ""
$logFile = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\$application Installation_Configuration.log"

# Function to write log messages to the file
function Write-Log([string]$message) {
    $timestamp = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
    $logEntry = "$timestamp - $message"
    Add-Content -Path $logFile -Value $logEntry
}

$process_names = "", ""
$processes = @(Get-Process -Name $process_names -ErrorAction SilentlyContinue)

if ($processes.Count -eq 0) {
    Try {
        $message = "$process_names are not running, we can run the installation in session 0"        
        Write-Log $message
        Start-Process -FilePath .\Deploy-Application.exe -Wait -ArgumentList '-DeploymentType "Install" -DeployMode "Silent"'
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
        $message = "$process_names are running, we need to run the installation in session 1 using ServiceUI.exe"        
        Write-Log $message
        .\ServiceUI.exe -process:explorer.exe Deploy-Application.exe -DeploymentType "Install"
        $exit_code = $LASTEXITCODE
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Log $ErrorMessage
        $exit_code = 1
    }
}

Write-Log $message
exit $exit_code