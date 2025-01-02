@echo off
setlocal enabledelayedexpansion

:: Enable debugging for troubleshooting
echo Starting organization by month...
pause

:: Loop through all files in the current folder
for %%f in (*.*) do (
    :: Extract the year and month (YYYYMM) from the filename
    for /f "tokens=1 delims=-" %%a in ("%%~nf") do (
        set "month_folder=%%a"
        set "month_folder=!month_folder:~0,6!"
    )
    
    :: Check if the extracted folder name (month_folder) is valid
    if "!month_folder!" NEQ "" (
        echo Processing file: %%f
        echo Extracted folder name: !month_folder!
        if "!month_folder:~0,6!"=="!month_folder!" (
            :: Create folder if it doesn’t exist
            if not exist "!month_folder!" (
                mkdir "!month_folder!"
                echo Created folder: !month_folder!
            )
            :: Move the file to the folder
            move "%%f" "!month_folder!\"
            echo Moved file %%f to folder !month_folder!
        ) else (
            echo Skipping file %%f (invalid date format)
        )
    ) else (
        echo Skipping file %%f (no date found)
    )
)

echo Organization completed!
pause