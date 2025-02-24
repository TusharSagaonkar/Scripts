@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: Ask for metadata file
set /p METADATA_FILE="Enter Metadata File Name (including .txt): "
IF NOT EXIST "%METADATA_FILE%" (
    echo Metadata file not found!
    pause
    exit /b
)

:: Read values from metadata file
FOR /F "tokens=1,* delims==" %%A IN (%METADATA_FILE%) DO (
    SET %%A=%%B
)

:: Display Retrieved Values
echo ====================================================
echo Metadata Retrieved from: %METADATA_FILE%
echo SCHEMA: %SCHEMA%
echo MODE: %MODE%
echo TABLES: %TABLES%
echo TABLE_COUNT: %TABLE_COUNT%
echo DUMPFILE: %DUMPFILE%
echo TIMESTAMP: %TIMESTAMP%
echo PARALLEL: %PARALLEL%
echo ====================================================

:: User Input to Modify Defaults
set /p SCHEMA="Enter Schema Name (default: %SCHEMA%): "
IF NOT DEFINED SCHEMA SET SCHEMA=%SCHEMA%

set /p DIRECTORY="Enter Directory Object (default: DATA_PUMP_DIR): "
IF NOT DEFINED DIRECTORY SET DIRECTORY=DATA_PUMP_DIR

set /p PARALLEL="Enter Parallel Workers (0 to disable, default: %PARALLEL%): "
IF NOT DEFINED PARALLEL SET PARALLEL=%PARALLEL%
IF "%PARALLEL%"=="0" (
    SET PARALLEL_OPTION=
) ELSE (
    SET PARALLEL_OPTION=PARALLEL=%PARALLEL%
)

set /p REMAP_SCHEMA="Enter Remap Schema (leave blank to skip): "
IF NOT DEFINED REMAP_SCHEMA (
    SET REMAP_OPTION=
) ELSE (
    SET REMAP_OPTION=REMAP_SCHEMA=%SCHEMA%:%REMAP_SCHEMA%
)

set /p TABLE_EXISTS_ACTION="Enter Table Exists Action (default: SKIP) [REPLACE/TRUNCATE/APPEND/SKIP]: "
IF NOT DEFINED TABLE_EXISTS_ACTION SET TABLE_EXISTS_ACTION=SKIP

set /p TABLES="Enter Specific Tables to Import (leave blank for all from metadata): "
IF NOT DEFINED TABLES SET TABLES=%TABLES%

:: Handle multiple dump files (if needed)
SET MULTI_DUMPFILE=%DUMPFILE:_%U=%
echo Using Dump Files: %MULTI_DUMPFILE%

:: Generate Log File Name
SET LOGFILE=IMPDP_%SCHEMA%_%MODE%_%TIMESTAMP%.log

:: Run IMPDP Command
IF "%MODE%"=="TABLE" (
    impdp system/password@%ORACLE_SID% DIRECTORY=%DIRECTORY% DUMPFILE=%MULTI_DUMPFILE% LOGFILE=%LOGFILE% TABLES=%TABLES% TABLE_EXISTS_ACTION=%TABLE_EXISTS_ACTION% %PARALLEL_OPTION% %REMAP_OPTION%
) ELSE (
    impdp system/password@%ORACLE_SID% DIRECTORY=%DIRECTORY% DUMPFILE=%MULTI_DUMPFILE% LOGFILE=%LOGFILE% TABLE_EXISTS_ACTION=%TABLE_EXISTS_ACTION% %PARALLEL_OPTION% %REMAP_OPTION%
)

echo Import completed. Check log file on the server: %LOGFILE%

:: Prevent CMD from closing immediately
pause