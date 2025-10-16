*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    ./ChromeOptionsHelper.py

*** Variables ***
${HAMK_URL}                https://www.hamk.fi
${HAMK_URL_EN}             https://www.hamk.fi/en
${BROWSER}                 Chrome
${TIMEOUT}                 10s
${IMPLICIT_WAIT}           5s

*** Keywords ***
Open HAMK Website
    [Arguments]    ${language}=fi
    [Documentation]    Opens the HAMK website in the specified language
    ${url}=    Set Variable If    '${language}' == 'en'    ${HAMK_URL_EN}    ${HAMK_URL}
    
    # Handle headless chrome with proper options
    Run Keyword If    '${BROWSER}' == 'headlesschrome'
    ...    Open Browser With Headless Chrome    ${url}
    ...    ELSE
    ...    Open Browser    ${url}    ${BROWSER}
    
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}

Open Browser With Headless Chrome
    [Arguments]    ${url}
    [Documentation]    Opens Chrome in headless mode with proper configuration
    ${chrome_options}=    Get Headless Chrome Options
    ${chrome_service}=    Get Chrome Service
    Create Webdriver    Chrome    options=${chrome_options}    service=${chrome_service}
    Go To    ${url}

Close HAMK Website
    [Documentation]    Closes the browser
    Close Browser

Wait For Page To Load
    [Documentation]    Waits for the page to load completely
    Wait Until Element Is Visible    //body    timeout=${TIMEOUT}

Accept Cookies If Present
    [Documentation]    Accepts cookies if the cookie banner is present
    ${cookie_present}=    Run Keyword And Return Status    
    ...    Wait Until Element Is Visible    xpath=//button[contains(., 'Accept') or contains(., 'Hyväksy')]    timeout=5s
    Run Keyword If    ${cookie_present}    Click Element    xpath=//button[contains(., 'Accept') or contains(., 'Hyväksy')]

Element Should Be Clickable
    [Arguments]    ${locator}
    [Documentation]    Verifies that an element is visible and enabled (clickable)
    Wait Until Element Is Visible    ${locator}    timeout=${TIMEOUT}
    Wait Until Element Is Enabled    ${locator}    timeout=${TIMEOUT}

Verify Link Is Working
    [Arguments]    ${locator}
    [Documentation]    Clicks a link and verifies the new page loads
    Element Should Be Clickable    ${locator}
    ${original_url}=    Get Location
    Click Element    ${locator}
    Wait For Page To Load
    ${new_url}=    Get Location
    Should Not Be Equal    ${original_url}    ${new_url}

Take Screenshot On Failure
    [Documentation]    Takes a screenshot when a test fails
    Run Keyword If Test Failed    Capture Page Screenshot    EMBED
