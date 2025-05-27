@echo off
setlocal

REM Prompt user to enter the full path to the SQL file
set /p sqlpath=Enter full path to .sql file (e.g. D:\scripts\hello.sql): 

REM Check if file exists
if not exist "%sqlpath%" (
    echo ERROR: The file "%sqlpath%" does not exist.
    exit /b 1
)

REM Extract folder, file name, and name without extension
set "sqldir=%~dp1"
set "sqlfile=%~nx1"
set "sqlbase=%~n1"
set "logfile=%sqlbase%.log"

REM Change directory to script folder
pushd "%sqldir%"

REM Create a temporary SQL wrapper that logs and calls the real script
(
echo SET SERVEROUTPUT ON;
echo SPOOL "%logfile%";
echo @%sqlfile%
echo SPOOL OFF;
echo EXIT;
) > __temp_run.sql

REM Run it with sqlplus
sqlplus your_user/your_password@your_db @__temp_run.sql

REM Clean up
del __temp_run.sql

popd
endlocal