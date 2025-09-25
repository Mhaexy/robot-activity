*** Settings ***
Resource    ../Resource/App.resource
Resource    ../Resource/CustomerPage.resource
variables      ../Variables/customerpage.py
variables      ../Variables/variables.py
Library     Collections

*** Keywords ***

Analyze And Validate Spending
   ${spent_users}=  Create Dictionary
   ${total_spending}=  Set Variable  0
   ${row_count}=  Get Element Count  ${table_row}
   ${total_spending}=  Calculate Total Spending From Table
   Log To Console  \n==================================
   Log To Console  Total Customer Spending: ${total_spending}
   Log To Console  ==================================
   Run Keyword If  ${total_spending} < 3500
   ...  Fail  FAIL: Total spending (${total_spending}) is below minimum threshold ($3500)
   ...  ELSE
   ...  Log To Console  PASS: Total spending (${total_spending}) meets minimum threshold ($3500)


Calculate Total Spending From Table
   ${total_spending}=  Set Variable  0
   ${row_count}=  Get Element Count  ${table_row}
   FOR  ${index}  IN RANGE  1  ${row_count}+1
       ${row_locator}=  Set Variable  (//table//tbody//tr)[${index}]
       ${name}=  Get Text  ${row_locator}//td[2]
       ${spent_text}=  Get Text  ${row_locator}//td[5]
       ${spent_value}=  Evaluate  float("""${spent_text}""".replace('$','').replace(',',''))
       IF  ${spent_value} > 0
           Log To Console  ${name}: ${spent_text}
           ${total_spending}=  Evaluate  ${total_spending} + ${spent_value}
       END
   END
   RETURN  ${total_spending}
