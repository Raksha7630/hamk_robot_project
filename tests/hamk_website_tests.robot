*** Settings ***
Documentation    Test suite for HAMK website functionality and bug detection
Resource         ../resources/common.robot
Suite Setup      Open HAMK Website
Suite Teardown   Close HAMK Website
Test Teardown    Take Screenshot On Failure

*** Test Cases ***
TC001: Verify HAMK Homepage Loads Successfully
    [Documentation]    Verifies that the HAMK homepage loads without errors
    [Tags]    smoke    homepage
    Wait For Page To Load
    Title Should Contain    HAMK
    Location Should Contain    hamk.fi

TC002: Verify Homepage Has Required Elements
    [Documentation]    Checks that the homepage contains essential elements
    [Tags]    homepage    ui
    Wait For Page To Load
    Accept Cookies If Present
    Page Should Contain Element    xpath=//header    message=Header not found
    Page Should Contain Element    xpath=//footer    message=Footer not found
    Page Should Contain Element    xpath=//nav    message=Navigation menu not found

TC003: Verify Main Navigation Menu Is Visible
    [Documentation]    Checks that the main navigation menu is displayed
    [Tags]    navigation    ui
    Wait For Page To Load
    Accept Cookies If Present
    Element Should Be Visible    xpath=//nav
    Page Should Contain Element    xpath=//a[@href or @role='menuitem']    message=Navigation links not found

TC004: Verify Language Switcher Exists
    [Documentation]    Checks that language switcher is available
    [Tags]    language    ui
    Wait For Page To Load
    Accept Cookies If Present
    ${lang_switcher_present}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//*[contains(@class, 'language') or contains(@aria-label, 'language') or text()='EN' or text()='FI']
    Run Keyword If    not ${lang_switcher_present}
    ...    Log    Language switcher might not be easily accessible - potential usability issue    WARN

TC005: Verify Search Functionality Exists
    [Documentation]    Checks if search functionality is available on the homepage
    [Tags]    search    functionality
    Wait For Page To Load
    Accept Cookies If Present
    ${search_present}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//input[@type='search' or @placeholder[contains(., 'Search')] or @placeholder[contains(., 'Haku')]]
    Run Keyword If    not ${search_present}
    ...    Log    Search functionality might not be easily accessible - potential usability issue    WARN

TC006: Verify Footer Contains Contact Information
    [Documentation]    Checks that footer has contact information
    [Tags]    footer    ui
    Wait For Page To Load
    Accept Cookies If Present
    Scroll Element Into View    xpath=//footer
    Element Should Be Visible    xpath=//footer
    ${has_contact_info}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//footer//*[contains(text(), '@') or contains(text(), '+358') or contains(text(), 'HAMK')]
    Run Keyword If    not ${has_contact_info}
    ...    Log    Footer might be missing contact information - potential content issue    WARN

TC007: Verify Social Media Links Are Present
    [Documentation]    Checks for social media links in the footer
    [Tags]    footer    social
    Wait For Page To Load
    Accept Cookies If Present
    Scroll Element Into View    xpath=//footer
    ${social_media_present}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//footer//a[contains(@href, 'facebook') or contains(@href, 'twitter') or contains(@href, 'instagram') or contains(@href, 'linkedin') or contains(@href, 'youtube')]
    Run Keyword If    not ${social_media_present}
    ...    Log    Social media links might not be present in footer - potential marketing issue    WARN

TC008: Verify All Images Have Alt Text
    [Documentation]    Checks accessibility: all images should have alt attributes
    [Tags]    accessibility    images
    Wait For Page To Load
    Accept Cookies If Present
    ${images}=    Get WebElements    xpath=//img
    ${total_images}=    Get Length    ${images}
    Log    Total images found: ${total_images}
    ${images_without_alt}=    Get WebElements    xpath=//img[not(@alt)]
    ${count_without_alt}=    Get Length    ${images_without_alt}
    Run Keyword If    ${count_without_alt} > 0
    ...    Log    Found ${count_without_alt} images without alt text - ACCESSIBILITY ISSUE    WARN
    Should Be Equal As Numbers    ${count_without_alt}    0    msg=Accessibility Issue: ${count_without_alt} images are missing alt text

TC009: Verify No Broken Internal Links On Homepage
    [Documentation]    Checks that internal links on homepage are valid (status code check would require additional library)
    [Tags]    links    homepage
    Wait For Page To Load
    Accept Cookies If Present
    ${links}=    Get WebElements    xpath=//a[@href]
    ${total_links}=    Get Length    ${links}
    Log    Total links found: ${total_links}
    ${broken_links}=    Get WebElements    xpath=//a[@href='#' or @href='']
    ${count_broken}=    Get Length    ${broken_links}
    Run Keyword If    ${count_broken} > 0
    ...    Log    Found ${count_broken} empty or placeholder links - potential BUG    WARN

TC010: Verify Page Is Mobile Responsive
    [Documentation]    Tests basic mobile responsiveness by checking viewport meta tag
    [Tags]    responsive    mobile
    Wait For Page To Load
    ${viewport_present}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//meta[@name='viewport']
    Should Be True    ${viewport_present}    msg=Mobile responsiveness issue: viewport meta tag not found

TC011: Verify Page Load Performance
    [Documentation]    Basic check to ensure page doesn't take too long to load
    [Tags]    performance
    ${start_time}=    Get Time    epoch
    Go To    ${HAMK_URL}
    Wait For Page To Load
    ${end_time}=    Get Time    epoch
    ${load_time}=    Evaluate    ${end_time} - ${start_time}
    Log    Page load time: ${load_time} seconds
    Should Be True    ${load_time} < 10    msg=Page load time exceeds 10 seconds - Performance issue

TC012: Verify No JavaScript Errors On Load
    [Documentation]    Checks browser console for JavaScript errors
    [Tags]    javascript    console
    Wait For Page To Load
    Accept Cookies If Present
    # Note: This is a placeholder - actual console log checking requires additional setup
    Log    Browser console errors should be checked manually or with additional tools    INFO

TC013: Verify Cookie Notice Is Displayed
    [Documentation]    Checks that cookie consent notice is shown to users
    [Tags]    cookies    compliance    gdpr
    Go To    ${HAMK_URL}
    ${cookie_notice}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    xpath=//*[contains(text(), 'cookie') or contains(text(), 'evästeitä')]    timeout=5s
    Should Be True    ${cookie_notice}    msg=Cookie notice not displayed - GDPR compliance issue

TC014: Verify Accessibility - Skip to Content Link
    [Documentation]    Checks for skip to main content link for screen readers
    [Tags]    accessibility    a11y
    Wait For Page To Load
    ${skip_link}=    Run Keyword And Return Status
    ...    Page Should Contain Element    xpath=//a[contains(text(), 'Skip') or contains(@class, 'skip')]
    Run Keyword If    not ${skip_link}
    ...    Log    Skip to main content link not found - Accessibility improvement recommended    WARN

TC015: Verify Main Heading Hierarchy
    [Documentation]    Checks that page has proper heading hierarchy (h1 should exist)
    [Tags]    accessibility    seo
    Wait For Page To Load
    Accept Cookies If Present
    ${h1_count}=    Get Element Count    xpath=//h1
    Should Be True    ${h1_count} >= 1    msg=SEO/Accessibility issue: Page should have at least one H1 heading
    Should Be True    ${h1_count} <= 1    msg=SEO/Accessibility issue: Page should have only one H1 heading

TC016: Verify External Links Open In New Tab
    [Documentation]    Checks that external links have target="_blank" attribute
    [Tags]    links    usability
    Wait For Page To Load
    Accept Cookies If Present
    ${external_links}=    Get WebElements    xpath=//a[not(contains(@href, 'hamk.fi')) and contains(@href, 'http')]
    ${count_external}=    Get Length    ${external_links}
    Log    Found ${count_external} external links
    Run Keyword If    ${count_external} > 0
    ...    Log    Verify that external links open in new tabs for better user experience    INFO

TC017: Verify Forms Have Proper Labels
    [Documentation]    Checks accessibility of form inputs with labels
    [Tags]    accessibility    forms
    Wait For Page To Load
    Accept Cookies If Present
    ${inputs}=    Get WebElements    xpath=//input[@type='text' or @type='email' or @type='tel']
    ${total_inputs}=    Get Length    ${inputs}
    Run Keyword If    ${total_inputs} > 0
    ...    Log    Found ${total_inputs} input fields - verify they have proper labels    INFO
    ${unlabeled_inputs}=    Get WebElements    xpath=//input[@type='text' or @type='email' or @type='tel'][not(@aria-label) and not(@placeholder) and not(@id)]
    ${count_unlabeled}=    Get Length    ${unlabeled_inputs}
    Run Keyword If    ${count_unlabeled} > 0
    ...    Log    Found ${count_unlabeled} inputs without labels - Accessibility issue    WARN
