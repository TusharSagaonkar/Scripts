@echo off
setlocal enabledelayedexpansion

:: Loop through all files in the current folder
for %%f in (*.*) do (
    :: Extract the year and month (YYYYMM) from the filename
    for /f "tokens=1 delims=-" %%a in ("%%~nf") do (
        set "month_folder=%%a"
        set "month_folder=!month_folder:~0,6!"
    )
    
    :: Check if the extracted month is valid (6 digits)
    if "!month_folder!" NEQ "" (
        if "!month_folder:~0,6!"=="!month_folder!" (
            :: Create folder if it doesn’t exist
            if not exist "!month_folder!" (
                mkdir "!month_folder!"
            )
            :: Move the file to the folder
            move "%%f" "!month_folder!\"
        ) else (
            echo Skipping file %%f (invalid date format)
        )
    ) else (
        echo Skipping file %%f (no date found)
    )
)

echo Files organized by month successfully!
pause