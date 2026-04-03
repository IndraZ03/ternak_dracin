@echo off
chcp 65001 >nul
title 🚀 Install FFmpeg N-122760-g33b215d155-20260217 (FIXED)
color 0b
echo.
echo ================================================
echo     Install FFmpeg Versi Spesifik + FIX MSSTORE
echo     Hash: g33b215d155 - 17 Feb 2026
echo ================================================
echo.

:: ====================== RUN AS ADMIN ======================
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [✓] Running as Administrator...
) else (
    echo [❌] Harus dijalankan sebagai Administrator!
    pause
    exit
)

:: ====================== FIX WINGET MSSTORE AGREEMENT ======================
echo [→] Memperbaiki Winget msstore agreement...
winget source update --accept-source-agreements >nul 2>&1
winget source reset --force >nul 2>&1
winget source update --accept-source-agreements >nul 2>&1

:: ====================== INSTALL 7-ZIP (jika belum ada) ======================
where 7z.exe >nul 2>&1
if %errorLevel% == 0 (
    echo [✓] 7-Zip sudah terinstall.
) else (
    echo [→] Menginstall 7-Zip otomatis...
    winget install --id 7zip.7zip -e --silent --accept-package-agreements --accept-source-agreements
    if %errorLevel% == 0 (
        echo [✓] 7-Zip berhasil diinstall.
    ) else (
        echo [⚠] Gagal install 7-Zip. Coba jalankan manual: winget install 7zip.7zip
        pause
        exit
    )
)

:: ====================== DOWNLOAD FFmpeg ======================
set "FFMPEG_URL=https://www.gyan.dev/ffmpeg/builds/ffmpeg-2026-02-15-git-33b215d155-full_build.7z"
set "DOWNLOAD_FILE=%~dp0ffmpeg-full.7z"
set "EXTRACT_DIR=C:\ffmpeg"

echo [→] Downloading FFmpeg versi yang kamu minta...
powershell -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri '%FFMPEG_URL%' -OutFile '%DOWNLOAD_FILE%'"

if not exist "%DOWNLOAD_FILE%" (
    echo [❌] Download gagal!
    pause
    exit
) else (
    echo [✓] Download berhasil.
)

:: ====================== EXTRACT ======================
echo [→] Extracting ke C:\ffmpeg ...
if not exist "%EXTRACT_DIR%" mkdir "%EXTRACT_DIR%"

7z x "%DOWNLOAD_FILE%" -o"%EXTRACT_DIR%" -y >nul

:: Pindah isi folder
for /d %%i in ("%EXTRACT_DIR%\ffmpeg-*") do (
    move "%%i\*" "%EXTRACT_DIR%" >nul 2>&1
    rmdir "%%i" /s /q
)

echo [✓] Extract selesai.

:: ====================== TAMBAHKAN KE PATH ======================
echo [→] Menambahkan ke PATH...
setx /M PATH "%PATH%;C:\ffmpeg\bin" >nul

:: ====================== VERIFY ======================
echo.
echo [→] Memeriksa versi FFmpeg...
ffmpeg -version | findstr /C:"N-122760-g33b215d155-20260217" >nul
if %errorLevel% == 0 (
    color 0a
    echo.
    echo ================================================
    echo     ✅ BERHASIL! FFmpeg sudah terinstall
    echo     Versi : N-122760-g33b215d155-20260217
    echo     Path  : C:\ffmpeg\bin
    echo ================================================
) else (
    echo [⚠] Versi tidak cocok. Tutup semua CMD/PowerShell lalu buka ulang.
)

echo.
echo Tekan tombol apa saja untuk keluar...
pause >nul