#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Akuntansi Go - Test Runner${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if flutter is installed
if ! command -v flutter &> /dev/null
then
    echo -e "${RED}Error: Flutter is not installed or not in PATH${NC}"
    exit 1
fi

# Parse command line arguments
COVERAGE=false
VERBOSE=false
SPECIFIC_TEST=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --coverage|-c)
            COVERAGE=true
            shift
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --test|-t)
            SPECIFIC_TEST="$2"
            shift
            shift
            ;;
        --help|-h)
            echo "Usage: ./run_tests.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -c, --coverage    Generate coverage report"
            echo "  -v, --verbose     Show verbose output"
            echo "  -t, --test FILE   Run specific test file"
            echo "  -h, --help        Show this help message"
            echo ""
            echo "Examples:"
            echo "  ./run_tests.sh                           # Run all tests"
            echo "  ./run_tests.sh --coverage                # Run with coverage"
            echo "  ./run_tests.sh -t test/models/           # Run model tests"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Clean before running tests
echo -e "${YELLOW}Cleaning project...${NC}"
flutter clean > /dev/null 2>&1
flutter pub get > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to get dependencies${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Dependencies ready${NC}"
echo ""

# Run tests
echo -e "${BLUE}Running tests...${NC}"
echo ""

if [ -n "$SPECIFIC_TEST" ]; then
    echo -e "${YELLOW}Running specific test: $SPECIFIC_TEST${NC}"
    if [ "$COVERAGE" = true ]; then
        flutter test "$SPECIFIC_TEST" --coverage
    else
        flutter test "$SPECIFIC_TEST"
    fi
else
    if [ "$COVERAGE" = true ]; then
        echo -e "${YELLOW}Running all tests with coverage...${NC}"
        flutter test --coverage
    else
        echo -e "${YELLOW}Running all tests...${NC}"
        flutter test
    fi
fi

TEST_EXIT_CODE=$?

echo ""

# Check test results
if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  ✓ All tests passed!${NC}"
    echo -e "${GREEN}========================================${NC}"
else
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}  ✗ Some tests failed${NC}"
    echo -e "${RED}========================================${NC}"
    exit $TEST_EXIT_CODE
fi

# Generate coverage report if requested
if [ "$COVERAGE" = true ]; then
    echo ""
    echo -e "${BLUE}Generating coverage report...${NC}"

    # Check if lcov is installed
    if command -v lcov &> /dev/null; then
        # Remove unwanted files from coverage
        lcov --remove coverage/lcov.info \
            '*/generated/*' \
            '*/l10n/*' \
            '*/.pub-cache/*' \
            '*/test/*' \
            -o coverage/lcov.info > /dev/null 2>&1

        # Generate HTML report
        if command -v genhtml &> /dev/null; then
            genhtml coverage/lcov.info -o coverage/html --quiet
            echo -e "${GREEN}✓ Coverage report generated${NC}"
            echo -e "${BLUE}  View at: coverage/html/index.html${NC}"

            # Show coverage summary
            echo ""
            echo -e "${YELLOW}Coverage Summary:${NC}"
            lcov --summary coverage/lcov.info 2>&1 | grep -E "lines\.\.\.\.\.\.|functions\.\.\.\.|branches\.\.\.\."
        else
            echo -e "${YELLOW}⚠ genhtml not found. Install with: sudo apt-get install lcov${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ lcov not found. Install with: sudo apt-get install lcov${NC}"
        echo -e "${BLUE}  Coverage data saved at: coverage/lcov.info${NC}"
    fi
fi

echo ""
echo -e "${GREEN}Done!${NC}"
exit 0
