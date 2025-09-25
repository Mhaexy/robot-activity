*** Settings ***
Resource    ../Resource/App.resource
Resource    ../Resource/CustomerPage.resource
variables      ../Variables/customerpage.py
variables      ../Variables/variables.py
Library     Collections

*** Keywords ***
Edit And Verify Last Five Users
    [Arguments]    ${users_to_edit}
    FOR    ${i}    IN RANGE    0    5
        ${table_row_index}=    Evaluate    ${i} + 6
        ${user_data}=    Set Variable    ${users_to_edit}[${i}]
        Go To Customers Page
        Click User In Specific Table Row    ${table_row_index}
        Edit User Form    ${user_data}
    END
    
Verify First Five Users In Table
    [Arguments]    ${users}
    Go To Customers Page
    Refresh Current Page
    ${row_count}=    Get Element Count    ${table_row}
    ${limit}=    Set Variable If    ${row_count} < 5    ${row_count}    5

    Should Be True    ${row_count} >= 5    Table does not have enough rows to verify 5 users.

    FOR    ${i}    IN RANGE    0    5
        ${current_user}=    Set Variable    ${users}[${i}]

        ${user_found}=    Set Variable    ${False}
        FOR    ${j}    IN RANGE    1    ${row_count}+1
            ${row_locator}=    Set Variable    ((${table_row})[${j}]//td)[2]
            ${fetched_name}=    Get Text    ${row_locator}
            IF    "\\n" in """${fetched_name}"""
                ${fetched_name}=    Evaluate    """${fetched_name}""".replace("\\n","")[1:]
            END

            ${name_parts}=    Split String    ${current_user["name"]}    ${SPACE}
            ${first_name}=    Set Variable    ${name_parts}[0]
            ${last_name}=    Set Variable    ${name_parts}[-1]
            ${expected_name}=    Set Variable    ${first_name} ${last_name}

            IF    '${fetched_name}' == '${expected_name}'
                ${user_found}=    Set Variable    ${True}
                Exit For Loop
            END
        END
        Should Be True    ${user_found}    User '${current_user["name"]}' was not found in the table.
    END 

Click User In Specific Table Row
    [Arguments]    ${row_index}
    ${name_locator}=    Set Variable    ((${table_row})[${row_index}]//td)[2]
    Wait Until Element Is Visible    ${name_locator}
    ${fetched_name}=    Get Text    ${name_locator}
    IF    "\\n" in """${fetched_name}"""
        ${fetched_name}    Evaluate    """${fetched_name}""".replace("\\n","")[1:]
    END
    
    Click Element    ${name_locator}
    Wait Until Element Is Visible    ${customers_txt_firstname}
Edit User Form
    [Arguments]    ${user}
    Wait Until Element Is Visible    ${customers_txt_firstname}

     Press Keys            ${customers_txt_firstname}    CTRL+a     BACKSPACE
    Input Text    ${customers_txt_firstname}    ${user["name"].split(" ")[0]}

     Press Keys            ${customers_txt_lastname}    CTRL+a     BACKSPACE
    Input Text    ${customers_txt_lastname}    ${user["name"].split(" ")[1]}

     Press Keys            ${customers_txt_email}    CTRL+a     BACKSPACE
    Input Text    ${customers_txt_email}    ${user["email"]}

     Press Keys            ${customers_txt_birthday}    BACKSPACE    TAB    BACKSPACE    TAB    BACKSPACE
    Input Text    ${customers_txt_birthday}    ${user["birthday"]}

    ${full_address}=    Set Variable    ${user["address"]["street"]} ${user["address"]["suite"]}
     Press Keys            ${customers_txt_address}    CTRL+a     BACKSPACE
    Input Text    ${customers_txt_address}    ${full_address}

     Press Keys            ${customers_txt_city}    CTRL+a     BACKSPACE
    Input Text    ${customers_txt_city}    ${user["address"]["city"]}

    Press Keys            ${customers_txt_stateAbbr}    CTRL+a     BACKSPACE
    Input Text    ${customers_txt_stateAbbr}    ${user["address"]["stateAbbr"]}

    Press Keys            ${customers_txt_zipcode}    CTRL+a     BACKSPACE
    Input Text    ${customers_txt_zipcode}    ${user["address"]["zipcode"]}

    Press Keys            ${customers_txt_password}    CTRL+a     BACKSPACE
    Input Text    ${customers_txt_password}    ${user["password"]}

    Press Keys            ${customers_txt_confirm_password}    CTRL+a     BACKSPACE
    Input Text    ${customers_txt_confirm_password}    ${user["password"]}

    Click Button    ${customers_txt_save}
    Wait Until Page Contains       Customer updated