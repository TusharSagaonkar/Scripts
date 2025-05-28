@echo off
setlocal enabledelayedexpansion

REM Prompt user for SQL file path
set /p sqlpath=Enter full path to .sql file (e.g. D:\scripts\hello.sql): 

REM Check if the file exists
if not exist "%sqlpath%" (
    echo ERROR: The file "%sqlpath%" does not exist.
    exit /b 1
)

REM Extract parts from the file path
for %%I in ("%sqlpath%") do (
    set "sqldir=%%~dpI"
    set "sqlfile=%%~nxI"
    set "sqlbase=%%~nI"
)

REM Format current date and time: YYYYMMDD_HHMMSS
for /f %%a in ('wmic os get localdatetime ^| find "."') do set dt=%%a
set "datetime=!dt:~0,8!_!dt:~8,6!"  REM YYYYMMDD_HHMMSS

REM Change to SQL file directory
pushd "!sqldir!"

REM Set log filename with datetime
set "logfile=!sqlbase!_!datetime!.log"

REM Create temp wrapper SQL file
(
echo SET SERVEROUTPUT ON;
echo SPOOL "!logfile!";
echo @!sqlfile!
echo SPOOL OFF;
echo EXIT;
) > __temp_run.sql

REM Run it
sqlplus your_user/your_password@your_db @__temp_run.sql

REM Clean up
del __temp_run.sql

popd
endlocal