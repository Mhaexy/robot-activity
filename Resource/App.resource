*** Settings ***


Library   SeleniumLibrary
variables  ../Variables/variables.py
Library    ../Library/CustomLibrary.py
Library    Collections
*** Variables ***


*** Keywords ***
Refresh Current Page
  Click Button       ${btn_refresh}
  Wait Until Element Is Visible       ${loading_icon}
  Wait Until Element Is Not Visible   ${loading_icon}
 
Login User
  [Arguments]        ${username}=${USERNAME}    ${password}=${PASSWORD}
  Input Text         ${login_txt_username}   ${username}
  Input Text         ${login_txt_password}   ${password}
  Click Button       ${login_btn_submit}
  ${status}   Run Keyword And Return Status   Wait Until Element Is Visible   ${dashboard_hdr}
  IF    ${status}
        Log To Console    Login Successful
  ELSE
        Log To Console    Login Failed
  END  




