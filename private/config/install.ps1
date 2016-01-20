# Installs the application based on the latest master repository source.
#
# Install:
# Copy to the project root directory on the target server.
#
# Run:
# Execute as a powershell script.
# eg.
# - From File Exporer -> right click on the filename + Run with Powershell
# - From Powershell window -> . c:\apps\local\doctransform\install.ps1
#
# Regardless of how it is launched it makes all it's directory references
# relative to it's location!!!
#

#
# Specific Configuration for this install
#
$githubArchiveUrl="https://github.com/EduShareGeorgian/doctransform/archive/master.zip"
$githubArchiveRootPath="doctransform-master"
$webAppPoolName="transformdoc"

# Default to stopping on errors vs. the default of continue!!
# See https://technet.microsoft.com/en-us/library/hh847796.aspx for behavior
$ErrorActionPreference="Stop"

$thisScriptPath = $($MyInvocation.MyCommand.Path)
Write-Output "Running script: $($thisScriptPath)"
$rootPath = Split-Path $thisScriptPath -parent
$buildRoot = "$($rootPath)\build"
$buildApplicationRoot = "$($buildRoot)\$($githubArchiveRootPath)"
Set-Location $rootPath
Write-Output "Current Path: $(Get-Location)"

#
# Get the latest from Github
#
function getLatestFromGithub() {
    $latestZipFilename = "latest.zip"
    Invoke-WebRequest $githubArchiveUrl -OutFile $latestZipFilename -Verbose
    #todo: if/when powershell 5 is available
    #Expand-Archive $latestZipFilename -Force
    & '7z' x $latestZipFilename
}

#
# Prepare latest build
#
function build() {
    # Cleanup filesystem from previous build
    if (Get-Item $buildRoot) {
        Write-Output "Removing old build directory $($buildRoot)"
        # Remove-Item : The specified path, file name, or both are too long. The fully qualified file name must be less than 260
        # The following is a hack to avoid the above error when using:
        #   Remove-Item -path $buildRoot -force -recurse -WarningAction "Ignore"
        & 'cmd' /C "rd $($buildRoot) /q /s"
    }
    New-Item $buildRoot -type directory

    Push-Location $buildRoot
    getLatestFromGithub

    # Build it
    Set-Location $buildApplicationRoot
    Write-Output "Installing Node Modules in $($buildApplicationRoot)"
    & 'npm' install --msvs_version=2012
    Remove-Item -path "result.html" -WarningAction "Ignore"
    Pop-Location
}

#
# Disable current runtime
#
function stopApplication() {
    $currentState = (Get-WebAppPoolState -Name $webAppPoolName).Value

    # stop IIS worker processes
    if ($currentState -ne "Stopped" ) {
        Stop-WebAppPool -Name $webAppPoolName -WarningAction "Ignore"
    }

    # wait for all Node processes to stop
    while ( $currentState -ne "Stopped" ) {
        Write-Output "Waiting for $webAppPoolName to stop ...; current state is $($currentState)"
        Start-Sleep -Seconds 5
        $currentState = (Get-WebAppPoolState -Name $webAppPoolName).Value
    }
}

#
# Backup the current version
#
function backup() {
    $backupFilename="backup\backup_$(Get-Date -Format 'yyyymmddThhmmssmsms').zip"
    Write-Output "Backing up current filesystem to $($backupFilename)"
    & 7z a $backupFilename current -x!current\node_modules
}

#
# Activate the latest build and start the application
#
function activateLatestBuild() {
    Remove-Item -path current -recurse -force -WarningAction "Ignore"  -ErrorAction "Ignore"
    Move-Item -path $buildApplicationRoot current -force
    # start IIS worker processes
    Start-WebAppPool -Name $webAppPoolName
}

#
# Mainline Install
#

#try {
    build
    stopApplication
    backup
    activateLatestBuild
#}
#catch {
#    Write-Host "Exiting with code 9999"
#    exit 9999
#}

