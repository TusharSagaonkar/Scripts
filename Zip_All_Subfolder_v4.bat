@echo off
:: Enable delayed expansion for variables inside loops
setlocal enabledelayedexpansion

:: Get the current directory
set "source_dir=%cd%"

:: Loop through each subfolder in the current directory
for /D %%D in (*) do (
    :: Get the name of the subfolder
    set "folder_name=%%~nxD"
    :: Define the output zip file name
    set "zip_file=%source_dir%\%%~nxD.zip"

    :: Check if the ZIP file already exists
    if exist "!zip_file!" (
        echo Skipping: "!folder_name!" (ZIP file already exists)
    ) else (
        :: Use the zip command to compress the folder
        zip -r "!zip_file!" "%%D"
        echo Zipped: "!folder_name!"
    )
)

echo Zipping complete!
pause