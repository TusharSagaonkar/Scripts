@echo off
setlocal enabledelayedexpansion

REM Prompt for SQL file
set /p sqlpath=Enter full path to .sql file (e.g. D:\scripts\hello.sql): 

if not exist "%sqlpath%" (
    echo ERROR: File "%sqlpath%" does not exist.
    exit /b 1
)

REM Prompt for DB user and DB name
set /p dbuser=Enter Oracle username: 
set /p dbname=Enter Oracle DB/service name: 

REM Extract path components
for %%I in ("%sqlpath%") do (
    set "sqldir=%%~dpI"
    set "sqlfile=%%~nxI"
    set "sqlbase=%%~nI"
)

REM Timestamp: YYYYMMDD_HHMMSS
for /f %%a in ('wmic os get localdatetime ^| find "."') do set dt=%%a
set "datetime=!dt:~0,8!_!dt:~8,6!"

REM Go to SQL file's folder
pushd "!sqldir!"

REM Log file name
set "logfile=!sqlbase!_!datetime!.log"

REM Temp wrapper SQL
(
echo SET SERVEROUTPUT ON;
echo SPOOL "!logfile!";
echo @!sqlfile!
echo SPOOL OFF;
echo EXIT;
) > __temp_run.sql

REM Run SQL*Plus — password will be securely prompted
sqlplus "!dbuser!@!dbname!" @__temp_run.sql

REM Cleanup
del __temp_run.sql

popd
endlocal