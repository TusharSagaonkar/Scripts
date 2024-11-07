@echo off
:: Set the path to the directory containing subfolders
set "source_dir=C:\path\to\your\directory"
:: Set the path to where 7z.exe is installed if not in PATH
set "zip_path=C:\Program Files\7-Zip\7z.exe"

:: Loop through each subfolder in the source directory
for /D %%D in ("%source_dir%\*") do (
    :: Get the name of the subfolder
    set "folder_name=%%~nxD"
    :: Define the output zip file name
    set "zip_file=%source_dir%\%folder_name%.zip"
    :: Create the zip file for each subfolder
    "%zip_path%" a -tzip "%zip_file%" "%%D\*"
)

echo Zipping complete!
pause
