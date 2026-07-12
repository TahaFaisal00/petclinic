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

Delete Owner Should Remove Row In Database
    [Documentation]     Creates a new Owner via API and asserts the response and its existence in Data
    ...                 Then Deletes this owner via API and asserts the status code and not trusting it and
    ...                 proceeds to verify if the owner is removed from the database.
    ${response}=     Create Owner Via API
    Verify Response Code        ${response}     ${CREATED_CODE}
    Verify Response Field Not Empty    ${response}    ${FIRST_NAME_FIELD_RESPONSE_MESSAGE}
    Owner Row Should Exist By Telephone         ${OWNER_DETAILS.telephone}
    ${response}=        Delete Owner Via API
    Verify Response Code    ${response}    ${NO_CONTENT_CODE}
    Owner Row Should Not Exist By Telephone    ${OWNER_DETAILS.telephone}
    [Teardown]    Run Keyword And Ignore Error          Delete Owner Via API

Add Pet To Owner Should Persist After Creation In Database
    [Documentation]     Creates a new Owner via API and asserts the response and its existence in Data
    ...                 Then creates a new pet for this owner via API and asserts the status code
    ...                 and not trusting it and proceeds to verify if the the new pet landed on the database
    ...                 and belongs to the given owner.
    ${response}=        Create Owner Via API
    Verify Response Code        ${response}     ${CREATED_CODE}
    Verify Response Field Not Empty    ${response}    ${FIRST_NAME_FIELD_RESPONSE_MESSAGE}
    Owner Row Should Exist By Telephone         ${OWNER_DETAILS.telephone}
    ${response}=        Add Pet To Owner Via API
    Verify Response Code        ${response}     ${CREATED_CODE}
    Pet Row Should Exist By Pet ID And Owner ID       ${PET_ID}       ${NEW_OWNER_ID}
    [Teardown]    Run Keywords
    ...           Run Keyword And Ignore Error        Delete Pet Via API    AND
    ...           Run Keyword And Ignore Error        Delete Owner Via API


