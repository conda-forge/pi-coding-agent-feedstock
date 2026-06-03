@echo on
setlocal enableextensions

:: Select the native prebuilt binaries for the TARGET architecture. This matters
:: when cross-compiling win-arm64 on a win-64 runner: without it npm would pull
:: the host's x64 optional dependencies instead of the arm64 ones.
set "NPM_CPU=x64"
if /i "%target_platform%"=="win-arm64" set "NPM_CPU=arm64"

:: Create package archive and install globally from local source
for /f "delims=" %%t in ('npm pack --ignore-scripts') do set "TGZ=%%t"
call npm install -ddd --global --cpu=%NPM_CPU% --os=win32 "%SRC_DIR%\%TGZ%"
if errorlevel 1 exit /b 1

:: Create license report for dependencies. --ignore-scripts avoids pnpm's
:: ERR_PNPM_IGNORED_BUILDS failure; dependency build scripts are irrelevant to
:: the license scan.
call pnpm install --ignore-scripts
if errorlevel 1 exit /b 1
call pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt
if errorlevel 1 exit /b 1
