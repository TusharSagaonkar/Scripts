@echo off
setlocal enabledelayedexpansion

:: Check if path is provided
if "%~1"=="" (
    echo Usage: %0 [source_path]
    exit /b 1
)

set "sourcePath=%~1"

:: Validate source path exists
if not exist "%sourcePath%" (
    echo Error: Source path does not exist.
    exit /b 1
)

:: Logging
set "logFile=%sourcePath%\file_move_log.txt"
echo Batch File Processing Started: %date% %time% > "%logFile%"

:: Process files
for /r "%sourcePath%" %%F in (*) do (
    set "filename=%%~nxF"
    set "filepath=%%F"
    set "processedDate="

    :: Multiple date pattern matching
    for /f "tokens=*" %%a in ('powershell -Command "$filename='!filename!'; if ($filename -match '(\d{4})[-_./]?(\d{2})[-_./]?(\d{2})') { Write-Output '$1$2$3' }"') do (
        set "processedDate=%%a"
    )

    if defined processedDate (
        set "destFolder=%sourcePath%\!processedDate!"
        
        :: Create destination folder if not exists
        if not exist "!destFolder!" mkdir "!destFolder!"

        :: Move file
        move "!filepath!" "!destFolder!\%%~nxF"

        :: Log movement
        echo Moved: %%~nxF to !destFolder! >> "%logFile%"
    )
)

:: Final logging
echo Batch File Processing Completed: %date% %time% >> "%logFile%"
echo File organization complete.
