*** Settings ***
Library           SeleniumLibrary
Library     CryptoLibrary    variable_decryption=True


*** Variable ***
${url_demo}        URL DEMO
${input_username}          //*[@id="input-username"]
${input_password}          //*[@id="input-password"]
${btn_next}           //*[@id="btn-next"]
${btn_login}            //*[@id="btn-login]
${username_success}            USERNAME
${menu_id}                  //*[@id="module-menu"]
${password}    Evaluate    window.atob('ENCRYPTED PASSWORD')
${BROWSER}        chrome
*** Test Cases ***
Open Browser and Login
    Open Browser    ${url_demo}    ${BROWSER}    window_size=1344x768    options=add_argument("--no-sandbox");add_argument("--disable-dev-shm-usage")
    ${password}    Execute JavaScript    return atob('ENCRYPTED PASSWORD');    
    Maximize Browser Window
    Wait Until Page Contains Element    ${input_username}    timeout=10s
    Input Text    ${input_username}    ${username_success}
    Click Element    id=btn-next
    Wait Until Page Contains Element    ${input_password}    timeout=10s
    Input Text    ${input_password}    ${password}
    Click Element    id=btn-login
    # Sleep    5s   # Adjust the sleep time as needed to wait for the login process to complete
    Wait Until Element Is Visible    ${menu_id}    timeout=10s
    Close Browser
