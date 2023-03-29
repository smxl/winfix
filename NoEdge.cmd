@echo off
@title No Edge
ver 0.1

goto check_permissions
:check_permissions
	echo MUST Run as Administrator!
	net session >nul 2>&1
	if %errorLevel% == 0 (
		echo Success!
	) else (
		echo Failure!
            pause
		exit /b
	)

echo Remove Microsoft Edge

set "batchPath=%~dp0"
cd /d "%ProgramFiles(x86)%\Microsoft"
for /f "tokens=1 delims=\" %%i in ('dir /B /A:D "%ProgramFiles(x86)%\Microsoft\Edge\Application" ^| find "."') do (set "edge-version=%%i")
if defined edge-version (
    echo Replacing setup.exe in Edge/Core/WebView
    for %%a in (Edge\Application\%edge-version%\Installer\setup.exe EdgeCore\Application\%edge-version%\Installer\setup.exe EdgeWebView\Application\%edge-version%\Installer\setup.exe) do (
        copy /y "%batchPath%setup.exe" "%%a" >nul
    )
    echo Removing Edge/Core/WebView %edge-version%
    Edge\Application\%edge-version%\Installer\setup.exe --uninstall --force-uninstall --msedge --system-level
    EdgeCore\%edge-version%\Installer\setup.exe --uninstall --force-uninstall --msedge --system-level
    EdgeWebView\Application\%edge-version%\Installer\setup.exe --uninstall --force-uninstall --msedgewebview --system-level
) else (
    echo Edge not found
)

pause
exit /b
