@echo off
for /d %%F in (*) do (
    echo Creating zip for folder: %%F
    zip -r "%%F.zip" "%%F"
)
echo All folders have been zipped, including the folder structure.
pause