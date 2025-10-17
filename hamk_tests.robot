*** Settings ***
Library           SeleniumLibrary

** Variables ***
${URL}    https://www.hamk.fi/en/



*** Test Cases ***        
TC_UI_01 Latest News Section Verification
    [Documentation]    Verify that the Latest News section is present on the Hamk homepage.
    Open Browser    ${URL}    Chrome
    Sleep    3s  #wait for elements to load

    # Verify page should contain Latest News section
    Page Should Contain Element    xpath=//section[@id='latest-news']
    Sleep    3s  #wait for elements to load

    # Click one by one each tab (Info, News, Press Releases, Stories, Student Voice)
    Click Element    xpath=//section[@id='latest-news']//a[contains(text(),'Info')]
    Sleep    3s  #wait for elements to load

    #Click the first article for each topic and check that it leads to article page
    Click Element    xpath=//section[@id='latest-news']//div[contains(@class,'info-tab')]//a[1]
    Sleep    3s  #wait for elements to load
    #Verify that we are on relevant article page in info tab
    Page Should Contain   Info    
    Go Back
    Sleep    3s  #wait for elements to load    
    
    # Repeat for News tabs
    Click Element    xpath=//section[@id='latest-news']//a[contains(text(),'News')]
    Sleep    3s  #wait for elements to load
    #verify that we are on relevant article page in news tab
    Click Element    xpath=//section[@id='latest-news']//div[contains(@class,'news-tab')]//a[1]
    Sleep    3s  #wait for elements to load
    Page Should Contain   News
    Go Back
    Sleep    3s  #wait for elements to load

    # Repeat for Press Releases tab
    Click Element    xpath=//section[@id='latest-news']//a[contains(text(),'Press Releases')]
    Sleep    3s  #wait for elements to load
    #verify that we are on relevant article page in press releases tab
    Click Element    xpath=//section[@id='latest-news']//div[contains(@class,'press-releases-tab')]//a[1] 
    Sleep    3s  #wait for elements to load
    Page Should Contain   Press Releases
    Go Back
    Sleep    3s  #wait for elements to load

    # Repeat for Stories tab    
    Click Element    xpath=//section[@id='latest-news']//a[contains(text(),'Stories')]
    Sleep    3s  #wait for elements to load
    Click Element    xpath=//section[@id='latest-news']//div[contains(@class,'stories-tab')]//a[1]
    Sleep    3s  #wait for elements to load
    Page Should Contain   Stories
    Go Back
    Sleep    3s  #wait for elements to load

    # Repeat for Student Voice tab
    Click Element    xpath=//section[@id='latest-news']//a[contains(text(),'Student Voice')]
    Sleep    3s  #wait for elements to load
    Click Element    xpath=//section[@id='latest-news']//div[contains(@class,'student-voice-tab')]//a[1]
    Sleep    3s  #wait for elements to load
    Page Should Contain   Student Voice
    Go Back
    Sleep    3s  #wait for elements to load

    Close Browser
    