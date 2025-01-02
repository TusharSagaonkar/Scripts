@echo off
setlocal enabledelayedexpansion

:: Get the current directory
set "current_folder=%cd%"

:: Loop through all files in the current folder
for %%f in ("%current_folder%\*.*") do (
    :: Extract the date (YYYYMMDD) from the filename
    for /f "tokens=1 delims=-" %%a in ("%%~nf") do (
        set "date_folder=%%a"
    )
    
    :: Check if the extracted date is valid (8 digits)
    if "!date_folder!" == "" (
        echo Skipping file %%f (no date found)
    ) else (
        if not "!date_folder:~0,8!"=="!date_folder!" (
            echo Skipping file %%f (invalid date format)
        ) else (
            :: Create folder if it doesn’t exist
            if not exist "!date_folder!" (
                mkdir "!date_folder!"
            )
            :: Move the file to the folder
            move "%%f" "!date_folder!\"
        )
    )
)

echo Files organized successfully!
pause