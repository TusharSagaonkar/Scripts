@echo off
:: Enable delayed expansion for variables inside loops
setlocal enabledelayedexpansion

:: Get the current directory where the batch file is run
set "source_dir=%cd%"

:: Loop through each subfolder in the current directory
for /D %%D in ("%source_dir%\*") do (
    :: Get the name of the subfolder
    set "folder_name=%%~nxD"
    :: Define the temporary output zip file name
    set "zip_file=%source_dir%\!folder_name!.zip"
    :: Use PowerShell to zip the folder, including the folder itself
    powershell -command "Compress-Archive -Path '%%D\' -DestinationPath '!zip_file!'"
    :: Move the zip file into the corresponding folder
    move "!zip_file!" "%%D\"
)

echo Zipping complete!
pause
