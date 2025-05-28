@echo off
setlocal enabledelayedexpansion

REM ================== MANUALLY SET DEFAULTS HERE ==================
set "default_sqlpath=D:\scripts\hello.sql"
set "default_dbuser=scott"
set "default_dbname=orcl"
REM =================================================================

REM Prompt for SQL file
set /p sqlpath=Enter full path to .sql file [%default_sqlpath%]: 
if "%sqlpath%"=="" set "sqlpath=%default_sqlpath%"

if not exist "%sqlpath%" (
    echo ERROR: File "%sqlpath%" not found.
    exit /b 1
)

REM Prompt for DB user
set /p dbuser=Enter Oracle username [%default_dbuser%]: 
if "%dbuser%"=="" set "dbuser=%default_dbuser%"

REM Prompt for DB name
set /p dbname=Enter Oracle DB/service name [%default_dbname%]: 
if "%dbname%"=="" set "dbname=%default_dbname%"

REM Extract file parts
for %%I in ("%sqlpath%") do (
    set "sqldir=%%~dpI"
    set "sqlfile=%%~nxI"
    set "sqlbase=%%~nI"
)

REM Create timestamp YYYYMMDD_HHMMSS
for /f %%a in ('wmic os get localdatetime ^| find "."') do set dt=%%a
set "datetime=!dt:~0,8!_!dt:~8,6!"

REM Change to SQL file's folder
pushd "!sqldir!"

REM Generate log file name
set "logfile=!sqlbase!_!datetime!.log"

REM Create temporary SQL wrapper
(
echo SET SERVEROUTPUT ON;
echo SPOOL "!logfile!";
echo @!sqlfile!
echo SPOOL OFF;
echo EXIT;
) > __temp_run.sql

REM Run in SQL*Plus (asks for password securely)
sqlplus "!dbuser!@!dbname!" @__temp_run.sql

REM Cleanup
del __temp_run.sql

popd
endlocal