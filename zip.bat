@echo off

:: Define the source folder to zip
set "source_folder=myfolder"

:: Define the output ZIP file name
set "zip_file=archive.zip"

:: Use forfiles command to recursively zip the folder
forfiles /S /M * /C "cmd /c compress /F %zip_file% @file" "%source_folder%\*"

echo Zipping complete!
pause
