@echo off
REM Windows batch file to run Flutter tests

setlocal enabledelayedexpansion

echo ========================================
echo   Akuntansi Go - Test Runner (Windows)
echo ========================================
echo.

REM Check if Flutter is installed
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: Flutter is not installed or not in PATH
    exit /b 1
)

REM Parse command line arguments
set COVERAGE=false
set SPECIFIC_TEST=
set SHOW_HELP=false

:parse_args
if "%~1"=="" goto end_parse
if /i "%~1"=="--coverage" set COVERAGE=true
if /i "%~1"=="-c" set COVERAGE=true
if /i "%~1"=="--test" (
    set SPECIFIC_TEST=%~2
    shift
)
if /i "%~1"=="-t" (
    set SPECIFIC_TEST=%~2
    shift
)
if /i "%~1"=="--help" set SHOW_HELP=true
if /i "%~1"=="-h" set SHOW_HELP=true
shift
goto parse_args
:end_parse

if "%SHOW_HELP%"=="true" (
    echo Usage: run_tests.bat [OPTIONS]
    echo.
    echo Options:
    echo   -c, --coverage    Generate coverage report
    echo   -t, --test FILE   Run specific test file
    echo   -h, --help        Show this help message
    echo.
    echo Examples:
    echo   run_tests.bat                           # Run all tests
    echo   run_tests.bat --coverage                # Run with coverage
    echo   run_tests.bat -t test\models\           # Run model tests
    exit /b 0
)

REM Clean before running tests
echo Cleaning project...
call flutter clean >nul 2>&1
call flutter pub get >nul 2>&1

if %errorlevel% neq 0 (
    echo Failed to get dependencies
    exit /b 1
)

echo [32m✓ Dependencies ready[0m
echo.

REM Run tests
echo Running tests...
echo.

if defined SPECIFIC_TEST (
    echo Running specific test: %SPECIFIC_TEST%
    if "%COVERAGE%"=="true" (
        call flutter test "%SPECIFIC_TEST%" --coverage
    ) else (
        call flutter test "%SPECIFIC_TEST%"
    )
) else (
    if "%COVERAGE%"=="true" (
        echo Running all tests with coverage...
        call flutter test --coverage
    ) else (
        echo Running all tests...
        call flutter test
    )
)

set TEST_EXIT_CODE=%errorlevel%

echo.

REM Check test results
if %TEST_EXIT_CODE% equ 0 (
    echo ========================================
    echo   [32m✓ All tests passed![0m
    echo ========================================
) else (
    echo ========================================
    echo   [31m✗ Some tests failed[0m
    echo ========================================
    exit /b %TEST_EXIT_CODE%
)

REM Generate coverage report if requested
if "%COVERAGE%"=="true" (
    echo.
    echo Generating coverage report...

    REM Check if coverage file exists
    if exist coverage\lcov.info (
        echo [32m✓ Coverage data generated[0m
        echo   Coverage file: coverage\lcov.info
        echo.
        echo [33mNote: To view HTML coverage report:[0m
        echo   1. Install lcov tools (requires WSL or Git Bash)
        echo   2. Run: genhtml coverage/lcov.info -o coverage/html
        echo   3. Open: coverage/html/index.html
    ) else (
        echo [33m⚠ Coverage file not generated[0m
    )
)

echo.
echo [32mDone![0m
exit /b 0
