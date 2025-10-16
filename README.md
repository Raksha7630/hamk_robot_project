# HAMK Robot Framework Testing Project

This project contains automated tests for the HAMK (Häme University of Applied Sciences) website using Robot Framework and SeleniumLibrary.

## Project Structure

```
hamk_robot_project/
├── tests/                          # Test suites
│   ├── hamk_website_tests.robot   # Main website functionality tests
│   └── hamk_navigation_tests.robot # Navigation and usability tests
├── resources/                      # Shared resources
│   └── common.robot               # Common keywords and variables
├── results/                        # Test execution results (gitignored)
├── requirements.txt               # Python dependencies
└── README.md                      # This file
```

## Prerequisites

- Python 3.8 or higher
- pip (Python package manager)
- Google Chrome browser (or Firefox/Edge)
- ChromeDriver (automatically managed by Selenium Manager or webdriver-manager)
- **Internet access** to the HAMK website (https://www.hamk.fi)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/Raksha7630/hamk_robot_project.git
cd hamk_robot_project
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

## Running Tests

### Run all tests:
```bash
robot --outputdir results tests/
```

### Run specific test suite:
```bash
robot --outputdir results tests/hamk_website_tests.robot
robot --outputdir results tests/hamk_navigation_tests.robot
```

### Run tests with specific tags:
```bash
# Run only smoke tests
robot --outputdir results --include smoke tests/

# Run accessibility tests
robot --outputdir results --include accessibility tests/

# Run SEO tests
robot --outputdir results --include seo tests/

# Run navigation tests
robot --outputdir results --include navigation tests/
```

### Run tests in headless mode:
```bash
robot --outputdir results --variable BROWSER:headlesschrome tests/
```

### Run with different browser:
```bash
robot --outputdir results --variable BROWSER:firefox tests/
```

## Test Categories

The test suite is organized into the following categories:

### Functional Tests
- Homepage loading and accessibility
- Navigation functionality
- Search functionality
- Language switching (Finnish/English)
- Form validation

### UI/UX Tests
- Responsive design
- Mobile menu functionality
- Visual elements presence
- Logo and branding

### Accessibility Tests
- Alt text for images
- Proper heading hierarchy
- Skip to content links
- Form labels
- Keyboard navigation

### SEO Tests
- Meta tags presence
- Page titles
- Heading structure
- Descriptive content

### Compliance Tests
- Cookie consent (GDPR)
- Privacy policy links
- Accessibility statement
- HTTPS enforcement

### Performance Tests
- Page load time
- Resource loading

## Test Results

After running tests, check the `results/` directory for:
- `log.html` - Detailed test execution log
- `report.html` - Test execution summary report
- `output.xml` - Machine-readable test results
- Screenshots (if tests fail)

## Known Issues and Bugs

The test suite is designed to detect potential bugs and issues on the HAMK website. Common issues that may be detected include:

1. Missing alt text on images (accessibility)
2. Missing or improper meta tags (SEO)
3. Broken links or empty href attributes
4. Missing accessibility features
5. GDPR compliance gaps
6. Performance issues
7. Responsive design problems
8. Missing legal/compliance pages

## Contributing

To add new tests:

1. Add test cases to appropriate test suite file
2. Use descriptive test case names (TC###: Description)
3. Include proper tags for test categorization
4. Add documentation strings for each test
5. Follow existing test patterns and conventions

## Tags Reference

- `smoke` - Critical functionality tests
- `homepage` - Homepage specific tests
- `navigation` - Navigation and menu tests
- `accessibility` - WCAG/A11Y compliance tests
- `seo` - Search engine optimization tests
- `security` - Security-related tests
- `performance` - Performance tests
- `compliance` - Legal/GDPR compliance tests
- `mobile` - Mobile responsiveness tests
- `forms` - Form functionality tests

## Browser Compatibility

Tests are primarily designed for Chrome but can run on:
- Chrome/Chromium
- Firefox
- Edge
- Safari (with appropriate WebDriver)

## Troubleshooting

### Internet Connectivity
The test suite requires internet access to reach the HAMK website (https://www.hamk.fi). If you're running tests in a restricted environment:
- Ensure your network allows access to hamk.fi
- Check firewall settings
- Verify DNS resolution is working

### ChromeDriver issues:
The project uses `webdriver-manager` to automatically manage ChromeDriver. If you encounter issues:
```bash
pip install --upgrade webdriver-manager
```

### Timeout errors:
Increase timeout in `resources/common.robot`:
```robot
${TIMEOUT}    20s
```

### Element not found:
The website structure may have changed. Update locators in test files accordingly.

## License

This project is for educational and testing purposes.

## Contact

For questions or issues, please open an issue on GitHub.
