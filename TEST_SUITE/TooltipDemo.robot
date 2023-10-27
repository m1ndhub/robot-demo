*** Settings ***
Library           RequestsLibrary
Library           SeleniumLibrary
Test Setup        Login API  
Library     CryptoLibrary    variable_decryption=False

*** Variables ***
${Base URL}       DEMO_LOGIN_API
${Client ID}      clientapp
${url_demo}        DEMO_URL
${Authorization}  Basic Y2xpZW50YXBwOmFkbWlucGl4OTI=
${Accept-Language}  en;q=0.8
${BROWSER}        chrome



*** Test Cases ***

Page #1
    Go To   DEMO URL     
    Maximize Browser Window  
    Verify New Global Tooltip     a.btn:nth-child(2)
    Verify New Global Tooltip     .tb-warn-list > thead:nth-child(1) > tr:nth-child(1) > th:nth-child(1) > a:nth-child(1)
    Verify New Global Tooltip     .tb-warn-list > thead:nth-child(1) > tr:nth-child(1) > th:nth-child(3) > a:nth-child(1)
    Verify New Global Tooltip     div[id=demo] ul:nth-child(1) > li:nth-child(1) > a[class*=btn-qt]
    Close Browser

Page #2
    Go To     DEMO URL     
    Maximize Browser Window   
    Verify New Global Tooltip    a.btn    
    Close Browser

*** Keywords ***

DECRYPT PASSWORD
    Open Browser    https://google.com    ${BROWSER}    window_size=1344x768    options=add_argument("--no-sandbox");add_argument("--disable-dev-shm-usage")
    ${encrypted_password}    Execute Javascript    return atob('ENCRYPTED PASSWORD')
    Set Global Variable    ${password}    ${encrypted_password}
    Close Browser   
Login API
    ${username}    Set Variable    admin@demo.com
    DECRYPT PASSWORD
    ${headers}     Create Dictionary   Content-Type=application/x-www-form-urlencoded   Authorization=${Authorization}   Accept-Language=${Accept-Language}
    ${data}        Create Dictionary   username=${username}   password=${password}   grant_type=password   client_id=${Client ID}   
     # Create a session
    Create Session    MySession    ${Base URL}   verify=true
    # Send POST request using the session
    ${response}    POST On Session    MySession    /oauth/token    data=${data}   headers=${headers}
    Should Be Equal As Strings    ${response.status_code}   200
    ${body}        Set Variable    ${response.json()}
    @{keys}        Create List    refresh_token    access_token    username    userId
    Open Browser     ${url_demo}/base?key=${body['refresh_token']}  ${BROWSER}  window_size=1344x768    options=add_argument("--no-sandbox");add_argument("--disable-dev-shm-usage")
    Wait Until Element Is Enabled    css:a[id=module] span.module-text.align-center     timeout=20s
    Element Should Contain        css:a[id=module] span.module-text.align-center        TEST
    FOR    ${key}    IN    @{keys}
        Execute JavaScript    localStorage.setItem('${key}', '${body['${key}']}')
        Execute Javascript    console.log('${body['refresh_token']}')
    END
    

    

Verify Element Has Class
    [Arguments]    ${locator}    ${expected_class}
    ${element} =    Get Element Attribute    ${locator}    class
    Should Contain    ${element}    ${expected_class}


Verify New Global Tooltip
    [Arguments]    ${locator}
    Wait Until Element Is Visible    css=${locator}    timeout=50s
    Verify Element Has Class    css=${locator}    btn-qt
    Sleep            1s
    Mouse Over      css=${locator}
    Wait Until Element Is Visible    css=${locator} > div    timeout=50s
    Verify Element Has Class    css=${locator} > div     demo-tooltip



    