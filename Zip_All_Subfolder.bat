@echo off
:: Enable delayed expansion for variables inside loops
setlocal enabledelayedexpansion

:: Get the current directory where the batch file is run
set "source_dir=%cd%"

:: Loop through each subfolder in the current directory
for /D %%D in ("%source_dir%\*") do (
    :: Get the name of the subfolder
    set "folder_name=%%~nxD"
    :: Define the output zip file name in the same directory
    set "zip_file=%source_dir%\!folder_name!.zip"
    :: Use PowerShell to zip the subfolder
    powershell -command "Compress-Archive -Path '%%D\*' -DestinationPath '!zip_file!'"
)

echo Zipping complete!
pause
