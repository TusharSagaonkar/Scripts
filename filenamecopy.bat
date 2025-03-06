@echo off
setlocal

:: Set output file name
set "output=filenames.txt"

:: Clear the output file if it exists
if exist "%output%" del "%output%"

:: List all files in current folder and subfolders
for /r %%F in (*) do echo %%F >> "%output%"

echo File list saved to %output%
pause