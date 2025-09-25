*** Settings ***
Library        SeleniumLibrary
variables      ../Variables/customerpage.py
variables      ../Variables/variables.py
Resource       ../Resource/App.resource
Resource       ../Resource/Test1.resource
Resource       ../Resource/Test2.resource
Resource       ../Resource/Test3.resource
Resource       ../Resource/Test4.resource
*** Keywords ***

Go To Customers Page
   Click Element    ${nav_btn_customers}
   Wait Until Element Is Visible  //table//tbody
   Wait Until Element Is Visible  ${customers_btn_create}

Launch Browser
  [Arguments]       ${url}=${URL}     ${element_to_wait}=${login_txt_username}
  Open Browser      ${url}   chrome       options=add_argument("--start-maximized")
  Wait Until Keyword Succeeds   5x     .5s     Wait Until Element Is Visible     ${element_to_wait}
