#!/bin/bash

# HAMK Website Test Runner Script
# This script runs Robot Framework tests for the HAMK website

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}HAMK Website Test Runner${NC}"
echo "======================================"

# Create results directory if it doesn't exist
mkdir -p results

# Parse command line arguments
TAGS=""
BROWSER="Chrome"
SUITE=""

print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -t, --tags TAG         Run tests with specific tag (smoke, accessibility, seo, etc.)"
    echo "  -b, --browser BROWSER  Browser to use (chrome, firefox, headlesschrome)"
    echo "  -s, --suite FILE       Run specific test suite file"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Run all tests"
    echo "  $0 -t smoke                           # Run smoke tests only"
    echo "  $0 -t accessibility                   # Run accessibility tests"
    echo "  $0 -b firefox                         # Run with Firefox"
    echo "  $0 -s tests/hamk_website_tests.robot  # Run specific suite"
    echo ""
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--tags)
            TAGS="$2"
            shift 2
            ;;
        -b|--browser)
            BROWSER="$2"
            shift 2
            ;;
        -s|--suite)
            SUITE="$2"
            shift 2
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            print_usage
            exit 1
            ;;
    esac
done

# Build robot command
ROBOT_CMD="robot --outputdir results"

if [ -n "$TAGS" ]; then
    ROBOT_CMD="$ROBOT_CMD --include $TAGS"
    echo -e "${YELLOW}Running tests with tag: $TAGS${NC}"
fi

if [ -n "$BROWSER" ]; then
    ROBOT_CMD="$ROBOT_CMD --variable BROWSER:$BROWSER"
    echo -e "${YELLOW}Using browser: $BROWSER${NC}"
fi

if [ -n "$SUITE" ]; then
    ROBOT_CMD="$ROBOT_CMD $SUITE"
    echo -e "${YELLOW}Running suite: $SUITE${NC}"
else
    ROBOT_CMD="$ROBOT_CMD tests/"
    echo -e "${YELLOW}Running all test suites${NC}"
fi

echo ""
echo "Executing: $ROBOT_CMD"
echo ""

# Run the tests
eval $ROBOT_CMD

# Check exit code
EXIT_CODE=$?

echo ""
echo "======================================"
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
else
    echo -e "${YELLOW}Some tests failed. Check results/report.html for details.${NC}"
fi

echo ""
echo "Test results available at:"
echo "  - Report: results/report.html"
echo "  - Log:    results/log.html"
echo "  - Output: results/output.xml"

exit $EXIT_CODE
