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
echo 4. VIEW
echo 5. SEQUENCE
echo 6. TRIGGER
echo 7. PROCEDURE
echo 8. FUNCTION
echo 9. PACKAGE
echo 10. PACKAGE BODY
echo 11. TYPE
echo 12. TYPE BODY
echo 13. MATERIALIZED VIEW
echo 14. SYNONYM
echo 15. GRANT
echo 16. STATISTICS
echo 17. DB LINK
echo (Use comma-separated values, e.g., 1,3,5 for TABLE:EMP, CONSTRAINT, SEQUENCE)

set /p INCLUDE_NUM="Enter numbers for INCLUDE (or leave blank): "
IF "%INCLUDE_NUM%"=="" (
    SET INCLUDE_PARAM=
) ELSE (
    SET INCLUDE=
    FOR %%A IN (%INCLUDE_NUM%) DO (
        IF "%%A"=="1" SET INCLUDE=!INCLUDE!,TABLE:EMP
        IF "%%A"=="2" SET INCLUDE=!INCLUDE!,INDEX
        IF "%%A"=="3" SET INCLUDE=!INCLUDE!,CONSTRAINT
        IF "%%A"=="4" SET INCLUDE=!INCLUDE!,VIEW
        IF "%%A"=="5" SET INCLUDE=!INCLUDE!,SEQUENCE
        IF "%%A"=="6" SET INCLUDE=!INCLUDE!,TRIGGER
        IF "%%A"=="7" SET INCLUDE=!INCLUDE!,PROCEDURE
        IF "%%A"=="8" SET INCLUDE=!INCLUDE!,FUNCTION
        IF "%%A"=="9" SET INCLUDE=!INCLUDE!,PACKAGE
        IF "%%A"=="10" SET INCLUDE=!INCLUDE!,PACKAGE BODY
        IF "%%A"=="11" SET INCLUDE=!INCLUDE!,TYPE
        IF "%%A"=="12" SET INCLUDE=!INCLUDE!,TYPE BODY
        IF "%%A"=="13" SET INCLUDE=!INCLUDE!,MATERIALIZED VIEW
        IF "%%A"=="14" SET INCLUDE=!INCLUDE!,SYNONYM
        IF "%%A"=="15" SET INCLUDE=!INCLUDE!,GRANT
        IF "%%A"=="16" SET INCLUDE=!INCLUDE!,STATISTICS
        IF "%%A"=="17" SET INCLUDE=!INCLUDE!,DB LINK
    )
    SET INCLUDE=!INCLUDE:~1!  :: Remove leading comma
    SET INCLUDE_PARAM=INCLUDE=!INCLUDE!
)

echo.
echo Select objects to EXCLUDE (leave blank to skip):
echo 1. TABLE:EMP
echo 2. INDEX
echo 3. CONSTRAINT
echo 4. VIEW
echo 5. SEQUENCE
echo 6. TRIGGER
echo 7. PROCEDURE
echo 8. FUNCTION
echo 9. PACKAGE
echo 10. PACKAGE BODY
echo 11. TYPE
echo 12. TYPE BODY
echo 13. MATERIALIZED VIEW
echo 14. SYNONYM
echo 15. GRANT
echo 16. STATISTICS
echo 17. DB LINK
echo (Use comma-separated values, e.g., 2,6 for INDEX and TRIGGER)

set /p EXCLUDE_NUM="Enter numbers for EXCLUDE (or leave blank): "
IF "%EXCLUDE_NUM%"=="" (
    SET EXCLUDE_PARAM=
) ELSE (
    SET EXCLUDE=
    FOR %%B IN (%EXCLUDE_NUM%) DO (
        IF "%%B"=="1" SET EXCLUDE=!EXCLUDE!,TABLE:EMP
        IF "%%B"=="2" SET EXCLUDE=!EXCLUDE!,INDEX
        IF "%%B"=="3" SET EXCLUDE=!EXCLUDE!,CONSTRAINT
        IF "%%B"=="4" SET EXCLUDE=!EXCLUDE!,VIEW
        IF "%%B"=="5" SET EXCLUDE=!EXCLUDE!,SEQUENCE
        IF "%%B"=="6" SET EXCLUDE=!EXCLUDE!,TRIGGER
        IF "%%B"=="7" SET EXCLUDE=!EXCLUDE!,PROCEDURE
        IF "%%B"=="8" SET EXCLUDE=!EXCLUDE!,FUNCTION
        IF "%%B"=="9" SET EXCLUDE=!EXCLUDE!,PACKAGE
        IF "%%B"=="10" SET EXCLUDE=!EXCLUDE!,PACKAGE BODY
        IF "%%B"=="11" SET EXCLUDE=!EXCLUDE!,TYPE
        IF "%%B"=="12" SET EXCLUDE=!EXCLUDE!,TYPE BODY
        IF "%%B"=="13" SET EXCLUDE=!EXCLUDE!,MATERIALIZED VIEW
        IF "%%B"=="14" SET EXCLUDE=!EXCLUDE!,SYNONYM
        IF "%%B"=="15" SET EXCLUDE=!EXCLUDE!,GRANT
        IF "%%B"=="16" SET EXCLUDE=!EXCLUDE!,STATISTICS
        IF "%%B"=="17" SET EXCLUDE=!EXCLUDE!,DB LINK
    )
    SET EXCLUDE=!EXCLUDE:~1!  
    SET EXCLUDE_PARAM=EXCLUDE=!EXCLUDE!
)

:: Running expdp command with INCLUDE/EXCLUDE if selected
SET EXPORT_CMD=expdp system/password@%ORACLE_SID% DIRECTORY=%DIRECTORY% DUMPFILE=EXPDP_%SCHEMA%_%FILE_SUFFIX%_%DATETIME%_%%U.dmp LOGFILE=EXPDP_%SCHEMA%_%FILE_SUFFIX%_%DATETIME%.log FILESIZE=%FILESIZE% COMPRESSION=%COMPRESSION% VERSION=%EXPORT_VERSION%

IF NOT "%INCLUDE_PARAM%"=="" SET EXPORT_CMD=%EXPORT_CMD% %INCLUDE_PARAM%
IF NOT "%EXCLUDE_PARAM%"=="" SET EXPORT_CMD=%EXPORT_CMD% %EXCLUDE_PARAM%

echo Running: %EXPORT_CMD%
%EXPORT_CMD%