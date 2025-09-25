*** Settings ***
Resource    ../Resource/App.resource
Resource    ../Resource/CustomerPage.resource
variables      ../Variables/customerpage.py
variables      ../Variables/variables.py
Library     Collections

*** Keywords ***

Log Table Data
    Go To Customers Page
    Refresh Current Page
    Wait Until Element Is Visible    ${table_row}
    ${row_count}=    Get Element Count    ${table_row}
    Log To Console    \n--- Logging Customer Table Data (${row_count} Rows) ---
    
    FOR    ${i}    IN RANGE    1    ${row_count}+1
        Log To Console    \n====== User ${i} ======
        ${current_row_locator}=    Set Variable    (${table_row})[${i}]
        ${name_locator}=    Set Variable    ${current_row_locator}/td[2]//a/div
        ${raw_name}=    Get Text    ${name_locator}
        ${name}=    Evaluate    " ".join("""${raw_name}""".split()[1:])
        Log To Console    Name: ${name}
        
        ${last_seen_locator}=    Set Variable    ${current_row_locator}/td[3]
        ${last_seen}=    Get Text    ${last_seen_locator}
        Log To Console    Last seen: ${last_seen}
        
        ${orders_locator}=    Set Variable    ${current_row_locator}/td[4]
        ${orders}=    Get Text    ${orders_locator}
        Log To Console    Orders: ${orders}
        
        ${total_spent_locator}=    Set Variable    ${current_row_locator}/td[5]
        ${total_spent}=    Get Text    ${total_spent_locator}
        Log To Console    Total spent: ${total_spent}
        
        ${latest_purchase_locator}=    Set Variable    ${current_row_locator}/td[6]
        ${latest_purchase}=    Get Text    ${latest_purchase_locator}
        Log To Console    Latest purchase: ${latest_purchase}
        
        ${newsletter_locator}=    Set Variable    ${current_row_locator}/td[7]//*[@data-testid]
        ${has_newsletter}=    Get Element Attribute    ${newsletter_locator}    aria-label
        Log To Console    Has newsletter: ${has_newsletter}
        
        ${segment_locator}=    Set Variable    ${current_row_locator}/td[8]//span
        ${segment_spans}=    Get Webelements    ${segment_locator}
        
        ${segments}=    Create List
        FOR    ${seg}    IN    @{segment_spans}
            ${seg_text}=    Get Text    ${seg}
            Append To List    ${segments}    ${seg_text}
        END
        Log To Console    Segments: ${segments}
        
    END
    Log To Console    \n--- END OF TABLE DATA ---

