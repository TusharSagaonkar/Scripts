@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: Default values
SET ORACLE_SID=ORCL
SET DIRECTORY=DATA_PUMP_DIR
SET SCHEMA=SCOTT
SET TABLES=
SET FILESIZE=10G
SET EXPORT_VERSION=LATEST
SET PARALLEL=4
SET DATETIME=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%

:: User Input
set /p SCHEMA="Enter Schema Name (default: %SCHEMA%): "
IF NOT DEFINED SCHEMA SET SCHEMA=SCOTT

set /p TABLES="Enter Table(s) (comma-separated or blank for full schema): "
IF NOT DEFINED TABLES (
    SET MODE=SCHEMA
    SET FILE_SUFFIX=ALL
) ELSE (
    SET MODE=TABLE
    SET FILE_SUFFIX=!TABLES!
    SET FILE_SUFFIX=!FILE_SUFFIX:,=_!

    :: Prefix each table with schema name
    SET TABLES_WITH_SCHEMA=
    FOR %%T IN (%TABLES%) DO (
        SET TABLES_WITH_SCHEMA=!TABLES_WITH_SCHEMA!,%SCHEMA%.%%T
    )
    SET TABLES_WITH_SCHEMA=!TABLES_WITH_SCHEMA:~1!  :: Remove leading comma
)

set /p FILESIZE="Enter Dump File Size Limit (default: %FILESIZE%): "
IF NOT DEFINED FILESIZE SET FILESIZE=10G

set /p EXPORT_VERSION="Enter Export Version (default: %EXPORT_VERSION%): "
IF NOT DEFINED EXPORT_VERSION SET EXPORT_VERSION=LATEST

set /p PARALLEL="Enter Parallel Workers (0 to disable parallelism, default: %PARALLEL%): "
IF NOT DEFINED PARALLEL SET PARALLEL=4
IF "%PARALLEL%"=="0" (
    SET PARALLEL_OPTION=
) ELSE (
    SET PARALLEL_OPTION=PARALLEL=%PARALLEL%
)

:: Generate Dump and Log File Names
SET DUMPFILE=EXPDP_%SCHEMA%_%MODE%_%FILE_SUFFIX%_%DATETIME%_%U.dmp
SET LOGFILE=EXPDP_%SCHEMA%_%MODE%_%FILE_SUFFIX%_%DATETIME%.log
SET METADATA_FILE=EXPDP_%SCHEMA%_%MODE%_%FILE_SUFFIX%_%DATETIME%.txt

:: Write Metadata to a Local File for Future Use in impdp
(
    echo SCHEMA=%SCHEMA%
    echo MODE=%MODE%
    echo TABLES=%TABLES_WITH_SCHEMA%
    echo DUMPFILE=%DUMPFILE%
    echo TIMESTAMP=%DATETIME%
    echo PARALLEL=%PARALLEL%
) > %METADATA_FILE%

echo Metadata saved in: %METADATA_FILE%

:: Run expdp Command
IF "%MODE%"=="TABLE" (
    expdp system/password@%ORACLE_SID% DIRECTORY=%DIRECTORY% DUMPFILE=%DUMPFILE% LOGFILE=%LOGFILE% FILESIZE=%FILESIZE% COMPRESSION=ALL VERSION=%EXPORT_VERSION% %PARALLEL_OPTION% TABLES=%TABLES_WITH_SCHEMA%
) ELSE (
    expdp system/password@%ORACLE_SID% DIRECTORY=%DIRECTORY% DUMPFILE=%DUMPFILE% LOGFILE=%LOGFILE% FILESIZE=%FILESIZE% COMPRESSION=ALL VERSION=%EXPORT_VERSION% %PARALLEL_OPTION%
)

echo Export completed. Check log file on the server: %LOGFILE%