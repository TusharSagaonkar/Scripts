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

:: Determine filename suffix based on table count
IF NOT DEFINED TABLES (
    SET MODE=SCHEMA
    SET FILE_SUFFIX=ALL
) ELSE (
    SET MODE=TABLE
    FOR /F "tokens=1-4 delims=," %%A IN ("%TABLES%") DO (
        IF "%%D"=="" (
            SET FILE_SUFFIX=!TABLES!
            SET FILE_SUFFIX=!FILE_SUFFIX:,=_!
        ) ELSE (
            FOR /F %%X IN ('cmd /c echo %TABLES% ^| find /c ","') DO SET /A TABLE_COUNT=%%X+1
            IF !TABLE_COUNT! GTR 2 (
                SET FILE_SUFFIX=TABLES(!TABLE_COUNT!)
            ) ELSE (
                SET FILE_SUFFIX=!TABLES!
                SET FILE_SUFFIX=!FILE_SUFFIX:,=_!
            )
        )
    )
)

set /p FILESIZE="Enter Dump File Size Limit (e.g., 5G, 10G) (default: %FILESIZE%): "
IF NOT DEFINED FILESIZE SET FILESIZE=10G

set /p EXPORT_VERSION="Enter Export Version (e.g., 11.2, 12.1, 19c) (default: %EXPORT_VERSION%): "
IF NOT DEFINED EXPORT_VERSION SET EXPORT_VERSION=LATEST

set /p PARALLEL="Enter Parallel Workers (0 to disable parallelism) (default: %PARALLEL%): "
IF NOT DEFINED PARALLEL SET PARALLEL=4

:: Generate timestamp
FOR /F "tokens=2 delims==" %%I IN ('wmic OS Get localdatetime /value') DO SET DATETIME=%%I
SET DATETIME=%DATETIME:~0,8%_%DATETIME:~8,6%

:: Generate dump and log file names
SET DUMPFILE=EXPDP_%SCHEMA%_%FILE_SUFFIX%_%DATETIME%_%%U.dmp
SET LOGFILE=EXPDP_%SCHEMA%_%FILE_SUFFIX%_%DATETIME%.log

:: Running Data Pump Export
SET EXPORT_CMD=expdp system/password@%ORACLE_SID% DIRECTORY=%DIRECTORY% DUMPFILE=%DUMPFILE% LOGFILE=%LOGFILE% FILESIZE=%FILESIZE% COMPRESSION=%COMPRESSION% VERSION=%EXPORT_VERSION%

IF "%MODE%"=="SCHEMA" (
    SET EXPORT_CMD=%EXPORT_CMD% SCHEMAS=%SCHEMA%
) ELSE (
    SET EXPORT_CMD=%EXPORT_CMD% TABLES=%TABLES%
)

IF NOT "%PARALLEL%"=="0" SET EXPORT_CMD=%EXPORT_CMD% PARALLEL=%PARALLEL%

echo Running: %EXPORT_CMD%
%EXPORT_CMD%

echo Export Completed!
PAUSE