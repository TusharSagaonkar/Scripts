@echo off
setlocal enabledelayedexpansion

REM ==== Output file ====
set "OUTFILE=%~dp0System_Info_DB_%COMPUTERNAME%_%DATE:/=-%.txt"

REM ==== Get fingerprint parts ====
for /f "tokens=2 delims==" %%i in ('wmic cpu get ProcessorId /format:list ^| find "="') do set "CPUID=%%i"
for /f "tokens=2 delims==" %%i in ('wmic baseboard get SerialNumber /format:list ^| find "="') do set "MBID=%%i"
for /f "tokens=2 delims==" %%i in ('wmic bios get SerialNumber /format:list ^| find "="') do set "BIOSID=%%i"

set "FINGERPRINT=%CPUID%_%MBID%_%BIOSID%"

REM ==== Header for DB Import ====
(
echo MACHINE_FINGERPRINT=%FINGERPRINT%
echo COMPUTERNAME=%COMPUTERNAME%
echo USERNAME=%USERNAME%
echo DATE=%DATE%
echo TIME=%TIME%
) > "%OUTFILE%"

REM ==== System Info ====
echo [SYSTEMINFO] >> "%OUTFILE%"
for /f "delims=" %%i in ('systeminfo') do echo SYSTEMINFO=%%i >> "%OUTFILE%"

REM ==== CPU Info ====
echo [CPU_INFO] >> "%OUTFILE%"
for /f "delims=" %%i in ('wmic cpu get Name,Manufacturer,NumberOfCores,NumberOfLogicalProcessors,ProcessorId /format:list') do if not "%%i"=="" echo CPU=%%i >> "%OUTFILE%"

REM ==== Memory Info ====
echo [MEMORY_INFO] >> "%OUTFILE%"
for /f "delims=" %%i in ('wmic memorychip get BankLabel,Capacity,Manufacturer,Speed,SerialNumber /format:list') do if not "%%i"=="" echo MEMORY=%%i >> "%OUTFILE%"

REM ==== Motherboard Info ====
echo [MOTHERBOARD_INFO] >> "%OUTFILE%"
for /f "delims=" %%i in ('wmic baseboard get Manufacturer,Product,SerialNumber,Version /format:list') do if not "%%i"=="" echo MB=%%i >> "%OUTFILE%"

REM ==== BIOS Info ====
echo [BIOS_INFO] >> "%OUTFILE%"
for /f "delims=" %%i in ('wmic bios get Manufacturer,Name,Version,SerialNumber,ReleaseDate /format:list') do if not "%%i"=="" echo BIOS=%%i >> "%OUTFILE%"

REM ==== Disk Drives ====
echo [DISK_DRIVES] >> "%OUTFILE%"
for /f "delims=" %%i in ('wmic diskdrive get Model,Name,InterfaceType,SerialNumber,Size /format:list') do if not "%%i"=="" echo DISK=%%i >> "%OUTFILE%"

REM ==== Network Adapters ====
echo [NETWORK_ADAPTERS] >> "%OUTFILE%"
for /f "delims=" %%i in ('wmic nic where "NetEnabled=true" get Name,MACAddress,Speed /format:list') do if not "%%i"=="" echo NET=%%i >> "%OUTFILE%"

REM ==== Video Controller ====
echo [VIDEO_CONTROLLER] >> "%OUTFILE%"
for /f "delims=" %%i in ('wmic path win32_VideoController get Name,AdapterRAM,DriverVersion /format:list') do if not "%%i"=="" echo GPU=%%i >> "%OUTFILE%"

REM ==== DXDIAG Short Info ====
dxdiag /t "%TEMP%\dxdiag.txt" >nul
echo [DXDIAG] >> "%OUTFILE%"
for /f "delims=" %%i in ('type "%TEMP%\dxdiag.txt"') do if not "%%i"=="" echo DX=%%i >> "%OUTFILE%"
del "%TEMP%\dxdiag.txt"

REM ==== Finish ====
echo DATA SAVED TO: "%OUTFILE%"
pause