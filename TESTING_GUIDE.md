# HAMK Website Testing Guide

## Overview
This document provides comprehensive guidance on testing the HAMK website using the Robot Framework test suite.

## Test Coverage

### 1. Website Functionality Tests (`hamk_website_tests.robot`)
These tests verify core website functionality and identify potential bugs:

#### Smoke Tests
- **TC001**: Homepage loads successfully
- **TC002**: Required page elements (header, footer, navigation) exist

#### UI/UX Tests
- **TC003**: Main navigation menu visibility
- **TC004**: Language switcher availability
- **TC005**: Search functionality presence

#### Accessibility Tests (WCAG Compliance)
- **TC008**: All images have alt text
- **TC010**: Mobile responsive viewport meta tag
- **TC014**: Skip to content link for screen readers
- **TC015**: Proper heading hierarchy (H1)
- **TC017**: Form inputs have proper labels

#### SEO Tests
- **TC015**: Main heading hierarchy
- **TC012**: JavaScript error checking
- **TC016**: External links behavior

#### Compliance Tests
- **TC013**: Cookie consent notice (GDPR)
- **TC006**: Contact information in footer

#### Content Quality Tests
- **TC007**: Social media links presence
- **TC009**: No broken internal links
- **TC011**: Page load performance

### 2. Navigation Tests (`hamk_navigation_tests.robot`)
These tests focus on navigation, usability, and compliance:

#### Navigation Tests
- **TC101-TC104**: Navigation to key sections (About, Studies, Research, Contact)
- **TC105**: Breadcrumb navigation
- **TC107**: Logo links to homepage
- **TC111**: Footer links functionality

#### Language/Internationalization Tests
- **TC108**: Language switch to English
- **TC109**: Language switch to Finnish

#### Mobile/Responsive Tests
- **TC110**: Mobile menu toggle

#### SEO/Metadata Tests
- **TC112**: Page title quality
- **TC113**: Meta description tag

#### Legal/Compliance Tests
- **TC114**: Copyright information
- **TC115**: Accessibility statement (Finnish law requirement)
- **TC116**: Privacy policy link (GDPR)
- **TC117**: HTTPS enforcement

#### Quality Tests
- **TC118**: Favicon presence
- **TC119**: No Lorem Ipsum placeholder text
- **TC120**: Form validation

## Bug Detection Strategy

The test suite is designed to detect various types of bugs:

### 1. Accessibility Bugs (Priority: HIGH)
- Missing alt text on images
- Improper heading hierarchy
- Missing form labels
- Lack of skip navigation links

### 2. Compliance Bugs (Priority: HIGH)
- Missing GDPR cookie consent
- Missing privacy policy
- Missing accessibility statement
- Not using HTTPS

### 3. SEO Issues (Priority: MEDIUM)
- Missing or poor meta descriptions
- Multiple H1 tags or no H1 tags
- Empty or overly long page titles

### 4. Usability Bugs (Priority: MEDIUM)
- Broken or empty links
- Missing search functionality
- Poor mobile responsiveness
- Missing language switcher

### 5. Content Quality Issues (Priority: LOW)
- Lorem ipsum placeholder text
- Missing contact information
- Missing social media links

## Running Tests

### Quick Start
```bash
# Install dependencies
pip install -r requirements.txt

# Run all tests
robot --outputdir results tests/

# Or use the helper script
./run_tests.sh
```

### Running Specific Test Categories

#### Smoke Tests (Critical Functionality)
```bash
robot --outputdir results --include smoke tests/
```

#### Accessibility Tests
```bash
robot --outputdir results --include accessibility tests/
```

#### SEO Tests
```bash
robot --outputdir results --include seo tests/
```

#### Compliance Tests (GDPR, Legal)
```bash
robot --outputdir results --include compliance tests/
```

#### Navigation Tests
```bash
robot --outputdir results --include navigation tests/
```

#### Mobile/Responsive Tests
```bash
robot --outputdir results --include mobile tests/
```

### Running in Different Browsers

#### Chrome (default)
```bash
robot --outputdir results tests/
```

#### Firefox
```bash
robot --outputdir results --variable BROWSER:firefox tests/
```

#### Headless Chrome (for CI/CD)
```bash
robot --outputdir results --variable BROWSER:headlesschrome tests/
```

### Running Specific Test Cases
```bash
# Run a single test suite
robot --outputdir results tests/hamk_website_tests.robot

# Run a specific test by name
robot --outputdir results --test "TC001: Verify HAMK Homepage Loads Successfully" tests/

# Run multiple specific tests
robot --outputdir results --test "TC001*" --test "TC002*" tests/
```

## Interpreting Results

### Test Results Files
After running tests, check the `results/` directory:

1. **report.html** - Executive summary with statistics
   - Overall pass/fail rates
   - Test execution timeline
   - Statistics by tags

2. **log.html** - Detailed test execution log
   - Step-by-step test execution
   - Screenshots on failures
   - Keyword arguments and return values

3. **output.xml** - Machine-readable results
   - For integration with CI/CD tools
   - For custom reporting

### Understanding Test Outcomes

#### PASS
- Test executed successfully
- No bugs detected in that area

#### FAIL
- Bug or issue detected
- Check log.html for details
- Review the failure message for specifics

#### WARN (in logs)
- Potential issue detected
- May not cause test failure but indicates improvement area
- Review and decide if action needed

## Common Issues and Solutions

### ChromeDriver Issues
If you see ChromeDriver errors:
```bash
pip install --upgrade webdriver-manager
```

### Timeout Errors
If tests timeout frequently, increase the timeout value in `resources/common.robot`:
```robot
${TIMEOUT}    20s
```

### Element Not Found Errors
This usually means:
1. Website structure changed - update locators
2. Element takes time to load - increase implicit wait
3. Feature not available - expected behavior

### SSL/Certificate Errors
These are automatically handled by Selenium, but if issues persist:
```robot
# Add this to browser options if needed
${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
Call Method    ${options}    add_argument    --ignore-certificate-errors
```

## Best Practices

### 1. Run Tests Regularly
- Before major releases
- After significant website updates
- As part of CI/CD pipeline

### 2. Prioritize Bug Fixes
- HIGH: Accessibility and compliance issues
- MEDIUM: SEO and usability issues
- LOW: Content quality issues

### 3. Keep Tests Updated
- Update locators when website structure changes
- Add new tests for new features
- Remove obsolete tests

### 4. Use Appropriate Tags
When running tests in CI/CD:
- Use `smoke` tag for quick validation
- Use `accessibility` and `compliance` for mandatory checks
- Use all tests for comprehensive validation

## Continuous Integration

### Example GitHub Actions Workflow
```yaml
name: HAMK Website Tests

on: [push, pull_request, schedule]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-python@v2
        with:
          python-version: '3.9'
      - name: Install dependencies
        run: pip install -r requirements.txt
      - name: Run smoke tests
        run: robot --outputdir results --include smoke tests/
      - name: Run accessibility tests
        run: robot --outputdir results --include accessibility tests/
      - name: Upload results
        uses: actions/upload-artifact@v2
        if: always()
        with:
          name: test-results
          path: results/
```

## Contributing

### Adding New Tests
1. Follow the naming convention: `TC###: Descriptive Name`
2. Add appropriate tags
3. Include documentation string
4. Use existing keywords when possible
5. Log warnings for potential issues that shouldn't fail tests

### Test Tags Reference
- `smoke` - Critical functionality
- `homepage` - Homepage specific
- `navigation` - Navigation and menus
- `accessibility` / `a11y` - Accessibility compliance
- `seo` - Search engine optimization
- `security` - Security related
- `performance` - Performance tests
- `compliance` - Legal/GDPR compliance
- `mobile` / `responsive` - Mobile responsiveness
- `forms` - Form functionality
- `language` - Internationalization

## Support

For issues or questions:
1. Check the FAQ section in README.md
2. Review existing test logs
3. Open an issue on GitHub with:
   - Test case number
   - Browser and OS
   - Screenshots/logs
   - Expected vs actual behavior

## References

- [Robot Framework Documentation](https://robotframework.org/robotframework/)
- [SeleniumLibrary Documentation](https://robotframework.org/SeleniumLibrary/)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [GDPR Compliance](https://gdpr.eu/)
- [Finnish Accessibility Requirements](https://www.saavutettavuusvaatimukset.fi/)
