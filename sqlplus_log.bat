@echo off
setlocal enabledelayedexpansion

REM Prompt user for SQL file path
set /p sqlpath=Enter full path to .sql file (e.g. D:\scripts\hello.sql): 

REM Check if the file exists
if not exist "%sqlpath%" (
    echo ERROR: The file "%sqlpath%" does not exist.
    exit /b 1
)

REM Extract folder and file parts
for %%I in ("%sqlpath%") do (
    set "sqldir=%%~dpI"
    set "sqlfile=%%~nxI"
    set "sqlbase=%%~nI"
)

REM Move to the SQL file's directory
pushd "!sqldir!"

REM Set the log file name in the same location
set "logfile=!sqlbase!.log"

REM Create temporary wrapper SQL file
(
echo SET SERVEROUTPUT ON;
echo SPOOL "!logfile!";
echo @!sqlfile!
echo SPOOL OFF;
echo EXIT;
) > __temp_run.sql

REM Run using SQL*Plus
sqlplus your_user/your_password@your_db @__temp_run.sql

REM Clean up
del __temp_run.sql

popd
endlocal