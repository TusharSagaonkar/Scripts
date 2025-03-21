@echo off
setlocal

:: Set the backup directory
set "backup_dir=C:\path\to\backup\folder"

:: Set specific filenames (separate with spaces)
set "file_list=SOSAIM_Db BIUNICUS BIUNICUS_SECOND BIUNICUS_THIRD BIUNICUS_Fourth BIUINCUS_Utility BIUNICUS_INCREMENTAL"

:: Set the file extension
set "file_extension=*.bak"

:: Loop through each filename pattern
for %%F in (%file_list%) do (
    forfiles /p "%backup_dir%" /s /m "%%F_%file_extension%" /d -15 /c "cmd /c del @file"
)

echo Selected old MySQL backup files deleted successfully.