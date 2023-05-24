##Application_Detection.ps1
##Checks for the installation of "<Application Name>"

# TODO Set the name and version of the Application to check
$Application = "<Application Name>"
$Version = "<Application Version>"

# TODO Set the paths to the shortcut files for each Application
$ApplicationSC = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\$Application\$Application.lnk"

# Set the registry paths to check for program installation
$RegPath = 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\', 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\'

# Set the path to the log file
$logFile = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Detections\$Application $Version IME_Detection.log"

# Initialize variables
$allInstalled = $true
$output = ""

# Check if the Application is installed and has the correct version
$programInstalled = $false
foreach ($regPath in $RegPath) {
    $programKey = Get-ChildItem $regPath | Where-Object { $_.GetValue("DisplayName") -eq $Application -and $_.GetValue("DisplayVersion") -eq $Version }
    if ($programKey) {
        Write-Host "$Application $Version is installed"
        $output += "$Application $Version is installed`r`n"
        $programInstalled = $true
        break
    }
}
if (-not $programInstalled) {
    Write-Warning "$Application $Version is NOT installed"
    $output += "**** $Application $Version is NOT installed ****`r`n"
    $allInstalled = $false
}

# Check if the shortcut files for the Application are present
if (Test-Path $ApplicationSC) {
    Write-Host "$Application $Version shortcut file is present"
    $output += "$Application $Version shortcut file is present`r`n"
} Else {
    Write-Warning "$Application $Version shortcut file is NOT present"
    $output += "**** $Application $Version shortcut file is NOT present ****`r`n"
    $allInstalled = $false
}

if ($allInstalled) {
    Write-Host "$Application $Version is installed and the shortcut file is present."
    $output += "$Application $Version is installed and the shortcut file is present.`r`n"
    $exitCode = 0
}
else {
    Write-Warning "$Application $Version is NOT installed or the shortcut file is NOT present."
    $output += "*** $Application $Version is NOT installed or the shortcut file is NOT present ***.`r`n"
    $exitCode = 1
}

$output | Out-File $logFile -Append
Exit $exitCode
