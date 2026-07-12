*** Settings ***
Resource            ../Resources/API_RES.robot
Resource            ../Resources/DB_RES.robot
Suite Setup         Run Keywords     Open Session            Open PetClinic Database Connection
Suite Teardown      Close PetClinic Database Connection

*** Test Cases ***
Create Owner Should Persist After Creation In Database
    [Documentation]     Creates new owner via API and asserts the response then not trusting it
    ...                 and proceeds to verify if the new owner exists in the Database (oracle) or not.
    ...                 the owner is deleted after the test.
    ${response}=        Create Owner Via API
    Verify Response Code        ${response}     ${CREATED_CODE}
    Verify Response Field Not Empty    ${response}    ${FIRST_NAME_FIELD_RESPONSE_MESSAGE}
    Owner Row Should Exist By Telephone         ${OWNER_DETAILS.telephone}
    [Teardown]    Run Keyword And Ignore Error          Delete Owner Via API

Update Owner Should Persist Change in Database
    [Documentation]     Creates a new Owner via API and asserts the response and its existence in Data
    ...                 Then Updates this Owner via API and asserts the response code and not trusting it and
    ...                 proceeds to verify if the change land on the database.
    ${response}=     Create Owner Via API
    Verify Response Code        ${response}     ${CREATED_CODE}
    Verify Response Field Not Empty    ${response}    ${FIRST_NAME_FIELD_RESPONSE_MESSAGE}
    Owner Row Should Exist By Telephone         ${OWNER_DETAILS.telephone}
    ${response}=      Update Owner Via API
    Verify Response Code    ${response}    ${NO_CONTENT_CODE}
    Owner Row Should Exist By Telephone         ${OWNER_DETAILS.telephone}
    Owner City In Database Should Be        ${OWNER_DETAILS.telephone}      ${UPDATED_CITY}
    [Teardown]    Run Keyword And Ignore Error          Delete Owner Via API








