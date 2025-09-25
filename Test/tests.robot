*** Settings ***
Library        Collections
Resource       ../Resource/App.resource
Resource       ../Resource/CustomerPage.resource
Library        ../Library/CustomLibrary.py
Suite Setup    Launch Browser
Suite Teardown  Close All Browsers

*** Variables ***
${USERNAME}  demo
${PASSWORD}  demo
${URL}       https://marmelab.com/react-admin-demo


*** Test Cases ***
TEST_1_Add_First_5_Users_And_Verify_Table
   [Documentation]  TASK 1 and TASK 2: Adds the first 5 users and verifies them in the table.
   Login User
   Go To Customers Page
   Add First 5 Users From API


TEST_2_Update_Next_5_Customers
   [Documentation]  TASK 3: Updates users 6-10 with data from API users 6-10.
     ${users}    Get Users From API
    ${users_to_edit}    Set Variable    ${users}[5:]   
    Edit And Verify Last Five Users    ${users_to_edit}

TEST_3_Log_All_Table_Data
   [Documentation]  TASK 4: Logs all user data from the table to the console.
   Go To Customers Page
   Log Table Data


TEST_4_Analyze_User_Spending
   [Documentation]  TASK 5: Analyzes and validates user spending.
   Go To Customers Page
   Analyze And Validate Spending

