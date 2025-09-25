*** Settings ***
Resource    ../Resource/App.resource
Resource    ../Resource/CustomerPage.resource
variables      ../Variables/customerpage.py
variables      ../Variables/variables.py
Library     Collections

*** Keywords ***
 Add First 5 Users From API
   ${users}     Get Users From API
   Add Users  ${users}[0:5]
   Go To Customers Page
   Verify Users In Table  ${users}[0:5]
   Go To Customers Page
Add Users
   [Arguments]  ${users}
   FOR  ${user}  IN  @{users}
       Go To Customers Page
       Click Element  ${customers_btn_create}
       Wait Until Element Is Visible  ${customers_txt_firstname}
       Verify And Input User Data  ${user}
       Click Button  ${customers_txt_save}
       Wait Until Page Contains  Customer created
       Go To Customers Page                
       Refresh Customer Table Data          
   END

Refresh Customer Table Data
   [Documentation]  
   Wait Until Element Is Visible  ${btn_refresh}
   Click Element  ${btn_refresh}
   Wait Until Element Is Visible     ${loading_icon}  timeout=5s
   Wait Until Element Is Not Visible  ${loading_icon}  timeout=15s
   Wait Until Element Is Visible  //table//tbody

Verify And Input User Data
   [Arguments]  ${user}
   ${first_name}=  Set Variable  ${user["first_name"]}
   ${last_name}=  Set Variable  ${user["last_name"]}
  
   Clear Element Text  ${customers_txt_firstname}
   Input Text  ${customers_txt_firstname}  ${first_name}
   ${fetched_first_name}=  Get Value  ${customers_txt_firstname}
   Should Be Equal As Strings  ${fetched_first_name}  ${first_name}

   Clear Element Text  ${customers_txt_lastname}
   Input Text  ${customers_txt_lastname}  ${last_name}
   ${fetched_last_name}=  Get Value  ${customers_txt_lastname}
   Should Be Equal As Strings  ${fetched_last_name}  ${last_name}
  
   Clear Element Text  ${customers_txt_email}
   Input Text  ${customers_txt_email}  ${user["email"]}
   ${fetched_email}=  Get Value  ${customers_txt_email}
   Should Be Equal As Strings  ${fetched_email}  ${user["email"]}
  
   Input Text  ${customers_txt_birthday}  ${user["birthday"]}
  
   Clear Element Text  ${customers_txt_address}
   Input Text  ${customers_txt_address}  ${user["address"]["street"]} ${user["address"]["suite"]}
   ${fetched_address}=  Get Value  ${customers_txt_address}
   Should Be Equal As Strings  ${fetched_address}  ${user["address"]["street"]} ${user["address"]["suite"]}
  
   Clear Element Text  ${customers_txt_city}
   Input Text  ${customers_txt_city}  ${user["address"]["city"]}
   ${fetched_city}=  Get Value  ${customers_txt_city}
   Should Be Equal As Strings  ${fetched_city}  ${user["address"]["city"]}
  
   Clear Element Text  ${customers_txt_stateAbbr}
   Input Text  ${customers_txt_stateAbbr}  ${user["address"]["stateAbbr"]}
   ${fetched_state}=  Get Value  ${customers_txt_stateAbbr}
   Should Be Equal As Strings  ${fetched_state}  ${user["address"]["stateAbbr"]}

   Clear Element Text  ${customers_txt_zipcode}
   Input Text  ${customers_txt_zipcode}  ${user["address"]["zipcode"]}
   ${fetched_zipcode}=  Get Value  ${customers_txt_zipcode}
   Should Be Equal As Strings  ${fetched_zipcode}  ${user["address"]["zipcode"]}
  
   Clear Element Text  ${customers_txt_password}
   Input Text  ${customers_txt_password}  ${user["password"]}
   ${fetched_password}=  Get Value  ${customers_txt_password}
   Should Be Equal As Strings  ${fetched_password}  ${user["password"]}
  
   Clear Element Text  ${customers_txt_confirm_password}
   Input Text  ${customers_txt_confirm_password}  ${user["password"]}
   ${fetched_confirm_password}=  Get Value  ${customers_txt_confirm_password}
   Should Be Equal As Strings  ${fetched_confirm_password}  ${user["password"]}

Verify Users In Table
   [Arguments]  ${users}
   FOR  ${user}  IN  @{users}
       Table Should Contain User  ${user}
   END

Table Should Contain User
   [Arguments]    ${user}
   ${row_count}=    Get Element Count    //table//tbody//tr
   ${found}=    Set Variable    False

   FOR    ${index}    IN RANGE    1    ${row_count}+1
       ${cell_text}=    Get Text    //table//tbody//tr[${index}]/td[1]
       Run Keyword If    '${cell_text}' == '${user["name"]}'    Set Variable    ${found}    True
   END


