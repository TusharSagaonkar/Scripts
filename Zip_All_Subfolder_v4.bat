@echo off
:: Get the current directory where the batch file is run
set "source_dir=%cd%"

:: Loop through each subfolder in the current directory
for /D %%D in ("%source_dir%\*") do (
    :: Get the name of the subfolder
    set "folder_name=%%~nxD"
    :: Define the output zip file name in the same directory
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