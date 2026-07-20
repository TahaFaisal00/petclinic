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
    [Tags]              functional      api       db       post       positive      owner
    ${response}=        Create Owner Via API
    Verify Response Code        ${response}     ${CREATED_CODE}
    Verify Response Field Not Empty    ${response}    ${FIRST_NAME_FIELD_RESPONSE_MESSAGE}
    Owner Row Should Exist By Telephone         ${OWNER_DETAILS.telephone}
    [Teardown]    Run Keyword And Ignore Error          Delete Owner Via API

Update Owner Should Persist Change in Database
    [Documentation]     Creates a new Owner via API and asserts the response and its existence in Database
    ...                 Then Updates this Owner via API and asserts the response code and not trusting it and
    ...                 proceeds to verify if the change land on the database.
    [Tags]              functional      api       db       put       positive      owner
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
    [Documentation]     Creates a new Owner via API and asserts the response and its existence in Database
    ...                 Then Deletes this owner via API and asserts the status code and not trusting it and
    ...                 proceeds to verify if the owner is removed from the database.
    [Tags]              functional      api       db       delete       positive      owner
    ${response}=     Create Owner Via API
    Verify Response Code        ${response}     ${CREATED_CODE}
    Verify Response Field Not Empty    ${response}    ${FIRST_NAME_FIELD_RESPONSE_MESSAGE}
    Owner Row Should Exist By Telephone         ${OWNER_DETAILS.telephone}
    ${response}=        Delete Owner Via API
    Verify Response Code    ${response}    ${NO_CONTENT_CODE}
    Owner Row Should Not Exist By Telephone    ${OWNER_DETAILS.telephone}
    [Teardown]    Run Keyword And Ignore Error          Delete Owner Via API

Add Pet To Owner Should Persist After Creation In Database
    [Documentation]     Creates a new Owner via API and asserts the response and its existence in Database
    ...                 Then creates a new pet for this owner via API and asserts the status code and response message
    ...                 and not trusting it and proceeds to verify if the new pet landed on the database
    ...                 and belongs to the given owner.
    [Tags]              functional      api       db       post       positive      owner
    ${response}=        Create Owner Via API
    Verify Response Code        ${response}     ${CREATED_CODE}
    Verify Response Field Not Empty    ${response}    ${FIRST_NAME_FIELD_RESPONSE_MESSAGE}
    Owner Row Should Exist By Telephone         ${OWNER_DETAILS.telephone}
    ${response}=        Add Pet To Owner Via API
    Verify Response Code        ${response}     ${CREATED_CODE}
    Verify Response Field Not Empty    ${response}    ${NAME_FIELD_RESPONSE_MESSAGE}
    Pet Row Should Exist By Pet ID And Owner ID       ${PET_ID}       ${NEW_OWNER_ID}
    [Teardown]    Run Keywords
    ...           Run Keyword And Ignore Error        Delete Pet Via API    AND
    ...           Run Keyword And Ignore Error        Delete Owner Via API

Create Owner Pet And Visit Should Persist In Database
    [Documentation]     Creates a new Owner via API and asserts the response and its existence in Database
    ...                 Then creates a new pet for this owner via API and asserts the status code and response message
    ...                 and its existence in Database and then creates a vet visit for this pet and asserts its
    ...                 Response message and code  and not trusting it and proceeds to verify if the
    ...                 new pet visit landed on the database and belongs to the given pet.
    [Tags]              functional      api       db       post       positive      owner
    ${response}=        Create Owner Via API
    Verify Response Code        ${response}     ${CREATED_CODE}
    Verify Response Field Not Empty    ${response}    ${FIRST_NAME_FIELD_RESPONSE_MESSAGE}
    Owner Row Should Exist By Telephone         ${OWNER_DETAILS.telephone}
    ${response}=        Add Pet To Owner Via API
    Verify Response Code        ${response}     ${CREATED_CODE}
    Pet Row Should Exist By Pet ID And Owner ID       ${PET_ID}       ${NEW_OWNER_ID}
    ${response}=        Create Vet Visit Via API
    Verify Response Code        ${response}     ${CREATED_CODE}
    Verify Response Field Not Empty    ${response}    ${DESCRIPTION_FIELD_RESPONSE_MESSAGE}
    Vet Visit Row Should Exist By Description And Pet ID    ${VET_VISIT_DESCRIPTION}      ${PET_ID}
    [Teardown]    Run Keywords
    ...           Run Keyword And Ignore Error        Delete Pet Via API    AND
    ...           Run Keyword And Ignore Error        Delete Owner Via API
