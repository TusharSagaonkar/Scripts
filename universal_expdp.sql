@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: Default values
SET ORACLE_SID=ORCL
SET DIRECTORY=DATA_PUMP_DIR
SET SCHEMA=SCOTT
SET TABLES=
SET INCLUDE=
SET EXCLUDE=
SET COMPRESSION=ALL
SET FILESIZE=10G
SET EXPORT_VERSION=LATEST
SET PARALLEL=4

:: User input
set /p ORACLE_SID="Enter ORACLE_SID (default: %ORACLE_SID%): "
IF NOT DEFINED ORACLE_SID SET ORACLE_SID=ORCL

set /p DIRECTORY="Enter Directory Object (default: %DIRECTORY%): "
IF NOT DEFINED DIRECTORY SET DIRECTORY=DATA_PUMP_DIR

set /p SCHEMA="Enter Schema Name (default: %SCHEMA%): "
IF NOT DEFINED SCHEMA SET SCHEMA=SCOTT

set /p TABLES="Enter Table(s) to Export (comma-separated or leave blank for full schema): "
IF NOT DEFINED TABLES (
    SET MODE=SCHEMA
    SET FILE_SUFFIX=ALL
) ELSE (
    SET MODE=TABLE
    SET FILE_SUFFIX=!TABLES!
    SET FILE_SUFFIX=!FILE_SUFFIX:,=_!
)

set /p FILESIZE="Enter Dump File Size Limit (e.g., 5G, 10G) (default: %FILESIZE%): "
IF NOT DEFINED FILESIZE SET FILESIZE=10G

set /p EXPORT_VERSION="Enter Export Version (e.g., 11.2, 12.1, 19c) (default: %EXPORT_VERSION%): "
IF NOT DEFINED EXPORT_VERSION SET EXPORT_VERSION=LATEST

set /p PARALLEL="Enter Parallel Workers (0 to disable parallelism) (default: %PARALLEL%): "
IF NOT DEFINED PARALLEL SET PARALLEL=4

:: Display Include/Exclude Options
echo.
echo Select objects to INCLUDE (leave blank to skip):
echo 1. TABLE:EMP
echo 2. INDEX
echo 3. CONSTRAINT
echo 4. TABLE:LOGS
echo (Use comma-separated values, e.g., 1,3 for TABLE:EMP and CONSTRAINT)

set /p INCLUDE_NUM="Enter numbers for INCLUDE (or leave blank): "
IF "%INCLUDE_NUM%"=="" (
    SET INCLUDE_PARAM=
) ELSE (
    SET INCLUDE=
    FOR %%A IN (%INCLUDE_NUM%) DO (
        IF "%%A"=="1" SET INCLUDE=!INCLUDE!,TABLE:EMP
        IF "%%A"=="2" SET INCLUDE=!INCLUDE!,INDEX
        IF "%%A"=="3" SET INCLUDE=!INCLUDE!,CONSTRAINT
        IF "%%A"=="4" SET INCLUDE=!INCLUDE!,TABLE:LOGS
    )
    SET INCLUDE=!INCLUDE:~1!  :: Remove leading comma
    SET INCLUDE_PARAM=INCLUDE=!INCLUDE!
)

echo.
echo Select objects to EXCLUDE (leave blank to skip):
echo 1. TABLE:EMP
echo 2. INDEX
echo 3. CONSTRAINT
echo 4. TABLE:LOGS
echo (Use comma-separated values, e.g., 2,4 for INDEX and TABLE:LOGS)

set /p EXCLUDE_NUM="Enter numbers for EXCLUDE (or leave blank): "
IF "%EXCLUDE_NUM%"=="" (
    SET EXCLUDE_PARAM=
) ELSE (
    SET EXCLUDE=
    FOR %%B IN (%EXCLUDE_NUM%) DO (
        IF "%%B"=="1" SET EXCLUDE=!EXCLUDE!,TABLE:EMP
        IF "%%B"=="2" SET EXCLUDE=!EXCLUDE!,INDEX
        IF "%%B"=="3" SET EXCLUDE=!EXCLUDE!,CONSTRAINT
        IF "%%B"=="4" SET EXCLUDE=!EXCLUDE!,TABLE:LOGS
    )
    SET EXCLUDE=!EXCLUDE:~1!  :: Remove leading comma
    SET EXCLUDE_PARAM=EXCLUDE=!EXCLUDE!
)

:: Generate timestamp
FOR /F "tokens=2 delims==" %%I IN ('wmic OS Get localdatetime /value') DO SET DATETIME=%%I
SET DATETIME=%DATETIME:~0,8%_%DATETIME:~8,6%

:: Generate dump and log file names with "EXPDP_" prefix
SET DUMPFILE=EXPDP_%SCHEMA%_%FILE_SUFFIX%_%DATETIME%_%%U.dmp
SET LOGFILE=EXPDP_%SCHEMA%_%FILE_SUFFIX%_%DATETIME%.log

:: Running Data Pump Export
echo Running Data Pump Export...
SET EXPORT_CMD=expdp system/password@%ORACLE_SID% DIRECTORY=%DIRECTORY% DUMPFILE=%DUMPFILE% LOGFILE=%LOGFILE% FILESIZE=%FILESIZE% COMPRESSION=%COMPRESSION% VERSION=%EXPORT_VERSION%

IF "%MODE%"=="SCHEMA" (
    SET EXPORT_CMD=%EXPORT_CMD% SCHEMAS=%SCHEMA%
) ELSE (
    SET EXPORT_CMD=%EXPORT_CMD% TABLES=%TABLES%
)

IF NOT "%PARALLEL%"=="0" SET EXPORT_CMD=%EXPORT_CMD% PARALLEL=%PARALLEL%
IF NOT "%INCLUDE_PARAM%"=="" SET EXPORT_CMD=%EXPORT_CMD% %INCLUDE_PARAM%
IF NOT "%EXCLUDE_PARAM%"=="" SET EXPORT_CMD=%EXPORT_CMD% %EXCLUDE_PARAM%

echo Running: %EXPORT_CMD%
%EXPORT_CMD%

echo Export Completed!
PAUSE