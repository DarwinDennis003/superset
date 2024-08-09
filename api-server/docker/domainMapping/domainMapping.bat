@echo off

:: BatchGotAdmin
:: -------------------------------------
:: Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else (
    goto gotAdmin
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:: --------------------------------------

@echo off
setlocal enabledelayedexpansion

set "domain=10.0.100.6 datalake.trias.in"
set "hosts_file=%SystemRoot%\System32\drivers\etc\hosts"

echo Adding %domain% to hosts file...

echo.>>"%hosts_file%"
echo %domain%>>"%hosts_file%"

echo Done.



REM Modify permissions for the hosts file to allow writing
icacls "%hostspath%" /grant:r "%USERNAME%:(OI)(CI)F" >nul 2>&1

start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --new-window "https://datalake.trias.in"

@echo off
setlocal

REM Set your Chrome path
set "chrome_path=C:\Program Files\Google\Chrome\Application\chrome.exe"

REM Set the URL of the site you want to create a shortcut for
set "site_url=https://datalake.trias.in"

REM Set the location where you want to save the shortcut
set "shortcut_location=%USERPROFILE%\Desktop\DATALAKE.lnk"

REM Set the location of the icon file
set "icon_location=%USERPROFILE%\OneDrive\Documents\domainMapping\trias.ico"

REM Create the shortcut
echo Creating shortcut for %site_url%...
echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo sLinkFile = "%shortcut_location%" >> CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
echo oLink.TargetPath = "%chrome_path%" >> CreateShortcut.vbs
echo oLink.Arguments = "%site_url%" >> CreateShortcut.vbs
echo oLink.IconLocation = "%icon_location%" >> CreateShortcut.vbs
echo oLink.Save >> CreateShortcut.vbs
cscript /nologo CreateShortcut.vbs
del CreateShortcut.vbs

echo Shortcut created at %shortcut_location%

endlocal


