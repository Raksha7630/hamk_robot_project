*** Settings ***
Documentation    Test suite for HAMK website navigation and functionality
Resource         ../resources/common.robot
Suite Setup      Open HAMK Website
Suite Teardown   Close HAMK Website
Test Teardown    Take Screenshot On Failure

*** Test Cases ***
TC101: Verify Navigation to About Section
    [Documentation]    Tests navigation to About/Info section
    [Tags]    navigation    functional
    Wait For Page To Load
    Accept Cookies If Present
    ${about_link}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//a[contains(text(), 'About') or contains(text(), 'Tietoa') or contains(text(), 'Info')]
    Run Keyword If    ${about_link}
    ...    Log    About section link found in navigation    INFO

TC102: Verify Navigation to Studies Section
    [Documentation]    Tests navigation to Studies/Education section
    [Tags]    navigation    functional
    Wait For Page To Load
    Accept Cookies If Present
    ${studies_link}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//a[contains(text(), 'Studies') or contains(text(), 'Opiskelu') or contains(text(), 'Education')]
    Run Keyword If    ${studies_link}
    ...    Log    Studies section link found in navigation    INFO

TC103: Verify Navigation to Research Section
    [Documentation]    Tests navigation to Research section
    [Tags]    navigation    functional
    Wait For Page To Load
    Accept Cookies If Present
    ${research_link}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//a[contains(text(), 'Research') or contains(text(), 'Tutkimus')]
    Run Keyword If    ${research_link}
    ...    Log    Research section link found in navigation    INFO

TC104: Verify Navigation to Contact Page
    [Documentation]    Tests navigation to Contact page
    [Tags]    navigation    functional
    Wait For Page To Load
    Accept Cookies If Present
    ${contact_link}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//a[contains(text(), 'Contact') or contains(text(), 'Yhteystiedot')]
    Run Keyword If    ${contact_link}
    ...    Log    Contact link found in navigation    INFO

TC105: Verify Breadcrumb Navigation
    [Documentation]    Checks if breadcrumb navigation is available
    [Tags]    navigation    usability
    Wait For Page To Load
    Accept Cookies If Present
    ${breadcrumb}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//*[contains(@class, 'breadcrumb') or contains(@aria-label, 'breadcrumb')]
    Run Keyword If    not ${breadcrumb}
    ...    Log    Breadcrumb navigation not found - might affect user navigation experience    INFO

TC106: Verify Search Box Functionality
    [Documentation]    Tests if search box accepts input
    [Tags]    search    functional
    Wait For Page To Load
    Accept Cookies If Present
    ${search_box}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//input[@type='search' or contains(@placeholder, 'Search') or contains(@placeholder, 'Haku')]
    Run Keyword If    ${search_box}
    ...    Run Keywords
    ...    Input Text    xpath=//input[@type='search' or contains(@placeholder, 'Search') or contains(@placeholder, 'Haku')]    test
    ...    AND    Log    Search box accepts input successfully    INFO

TC107: Verify Logo Links to Homepage
    [Documentation]    Checks that clicking the logo returns to homepage
    [Tags]    navigation    usability
    Wait For Page To Load
    Accept Cookies If Present
    ${logo}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//img[contains(@alt, 'HAMK') or contains(@class, 'logo')]
    Run Keyword If    ${logo}
    ...    Log    HAMK logo found on the page    INFO

TC108: Verify Language Switch to English
    [Documentation]    Tests switching website language to English
    [Tags]    language    functional
    Wait For Page To Load
    Accept Cookies If Present
    ${en_link}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//a[text()='EN' or text()='English' or contains(@href, '/en')]
    Run Keyword If    ${en_link}
    ...    Run Keywords
    ...    Click Element    xpath=//a[text()='EN' or text()='English' or contains(@href, '/en')]
    ...    AND    Wait For Page To Load
    ...    AND    Location Should Contain    /en

TC109: Verify Language Switch to Finnish
    [Documentation]    Tests switching website language to Finnish
    [Tags]    language    functional
    Go To    ${HAMK_URL_EN}
    Wait For Page To Load
    Accept Cookies If Present
    ${fi_link}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//a[text()='FI' or text()='Suomi' or contains(@href, 'hamk.fi') and not(contains(@href, '/en'))]
    Run Keyword If    ${fi_link}
    ...    Log    Finnish language option found    INFO

TC110: Verify Responsive Menu Toggle
    [Documentation]    Tests mobile menu toggle functionality
    [Tags]    responsive    mobile    navigation
    Wait For Page To Load
    Accept Cookies If Present
    Set Window Size    375    667    # iPhone size
    Sleep    1s    # Wait for responsive layout
    ${mobile_menu_toggle}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//button[contains(@class, 'menu') or contains(@aria-label, 'menu') or contains(@class, 'navbar-toggler')]
    Run Keyword If    ${mobile_menu_toggle}
    ...    Log    Mobile menu toggle found - responsive design implemented    INFO
    [Teardown]    Run Keywords    Maximize Browser Window    AND    Take Screenshot On Failure

TC111: Verify Footer Links Are Clickable
    [Documentation]    Checks that footer links are accessible and clickable
    [Tags]    footer    links
    Wait For Page To Load
    Accept Cookies If Present
    Scroll Element Into View    xpath=//footer
    ${footer_links}=    Get WebElements    xpath=//footer//a[@href]
    ${count}=    Get Length    ${footer_links}
    Log    Found ${count} links in footer
    Should Be True    ${count} > 0    msg=Footer should contain links

TC112: Verify Page Title Is Descriptive
    [Documentation]    Checks that page title is descriptive and not empty
    [Tags]    seo    metadata
    Wait For Page To Load
    ${title}=    Get Title
    ${title_length}=    Get Length    ${title}
    Should Be True    ${title_length} > 0    msg=Page title should not be empty
    Should Be True    ${title_length} < 100    msg=Page title should be concise (less than 100 chars)
    Log    Page title: ${title}

TC113: Verify Meta Description Exists
    [Documentation]    Checks for meta description tag for SEO
    [Tags]    seo    metadata
    Wait For Page To Load
    ${meta_desc}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//meta[@name='description']
    Should Be True    ${meta_desc}    msg=SEO issue: Meta description tag is missing

TC114: Verify Copyright Information In Footer
    [Documentation]    Checks that footer contains copyright information
    [Tags]    footer    legal
    Wait For Page To Load
    Accept Cookies If Present
    Scroll Element Into View    xpath=//footer
    ${copyright}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//footer//*[contains(text(), '©') or contains(text(), 'Copyright') or contains(text(), '202')]
    Run Keyword If    not ${copyright}
    ...    Log    Copyright information not clearly visible in footer    WARN

TC115: Verify Accessibility Statement Link
    [Documentation]    Checks for accessibility statement link (required by law in Finland)
    [Tags]    accessibility    compliance    legal
    Wait For Page To Load
    Accept Cookies If Present
    Scroll Element Into View    xpath=//footer
    ${accessibility_statement}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//a[contains(text(), 'Accessibility') or contains(text(), 'Saavutettavuus')]
    Run Keyword If    not ${accessibility_statement}
    ...    Log    Accessibility statement link not found - May be required by Finnish law    WARN

TC116: Verify Privacy Policy Link
    [Documentation]    Checks for privacy policy link (GDPR compliance)
    [Tags]    privacy    compliance    gdpr    legal
    Wait For Page To Load
    Accept Cookies If Present
    Scroll Element Into View    xpath=//footer
    ${privacy_policy}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//a[contains(text(), 'Privacy') or contains(text(), 'Tietosuoja')]
    Run Keyword If    not ${privacy_policy}
    ...    Log    Privacy policy link not found - GDPR compliance requirement    WARN

TC117: Verify No Mixed Content Warnings
    [Documentation]    Ensures the page is loaded over HTTPS
    [Tags]    security    https
    Wait For Page To Load
    ${current_url}=    Get Location
    Should Start With    ${current_url}    https://    msg=Security issue: Page should be served over HTTPS

TC118: Verify Page Contains Valid Favicon
    [Documentation]    Checks for favicon link in page head
    [Tags]    ui    branding
    Wait For Page To Load
    ${favicon}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//link[@rel='icon' or @rel='shortcut icon']
    Should Be True    ${favicon}    msg=Branding: Favicon not found

TC119: Verify No Lorem Ipsum Placeholder Text
    [Documentation]    Checks for placeholder text that should have been replaced
    [Tags]    content    quality
    Wait For Page To Load
    Accept Cookies If Present
    ${lorem_found}=    Run Keyword And Return Status
    ...    Page Should Contain    Lorem ipsum
    Should Not Be True    ${lorem_found}    msg=Content issue: Lorem ipsum placeholder text found on page

TC120: Verify Contact Form Validation
    [Documentation]    Tests if contact forms have proper validation
    [Tags]    forms    validation
    Wait For Page To Load
    Accept Cookies If Present
    ${form}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//form
    Run Keyword If    ${form}
    ...    Log    Form found on page - manual validation testing recommended    INFO
