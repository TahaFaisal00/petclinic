*** Settings ***
Library         RequestsLibrary
Library         FakerLibrary
Library         String
Library         Collections
Resource        ../Resources/TestData.robot

*** Keywords ***
Open Session
    [Documentation]     Open the shared HTTP session. Used as suite setup
    Create Session    ${ALIAS}    ${BASE_URL}

Create Owner Details
    [Documentation]     Creates a fake details for the create owner Via API keyword so it can create
    ...                 a new user with a fresh new data.
    ${faker_first_name}=            FakerLibrary.First Name Male
    ${faker_last_name}=             FakerLibrary.Last Name Male
    ${faker_address}=             FakerLibrary.Street Name
    ${faker_city}=                FakerLibrary.City
    ${raw_faker_telephone}=           FakerLibrary.Basic Phone Number
    ${faker_telephone}=        Remove String Using Regexp         ${raw_faker_telephone}     [^0-9]
    &{OWNER_DETAILS}        Create Dictionary       first_name=${faker_first_name}
    ...                     last_name=${faker_last_name}      address=${faker_address}
    ...                     city=${faker_city}       telephone=${faker_telephone}
    RETURN           &{OWNER_DETAILS}

Build Owner Body
    [Arguments]     ${owner}
    &{body}=    Create Dictionary    firstName=${owner.first_name}
    ...                     lastName=${owner.last_name}         address=${owner.address}
    ...                     city=${owner.city}         telephone=${owner.telephone}
    RETURN      ${body}

Send Create Owner request
    [Arguments]     ${body}
    ${response}=        POST On Session     ${ALIAS}        ${CREATE_OWNER_API}     json=${body}
    RETURN      ${response}

Create Owner Via API
    [Documentation]     Create a new owner by using a fresh details. can be used for test Setup
    ${owner}=            Create Owner Details
    VAR         &{OWNER_DETAILS}        &{owner}        scope=test
    ${body}=        Build Owner Body     ${owner}
    ${response}=        Send Create Owner request       ${body}
    VAR        ${NEW_OWNER_ID}            ${response.json()}[id]       scope=TEST
    RETURN            ${response}

Send Delete Owner Request
    ${delete_owner_api_with_id}=        Format String    ${DELETE_OWNER_API}     ${NEW_OWNER_ID}
    ${response}     DELETE On Session       ${ALIAS}      ${delete_owner_api_with_id}
    RETURN      ${response}

Delete Owner Via API
    [Documentation]     Delete owner by ID. Used as Test Teardown.
    ${response}=        Send Delete Owner Request
    RETURN      ${response}

Verify Response Code
    [Documentation]     Asserts the API status code equals the given value.
    [Arguments]         ${response}        ${response_code}
    Status Should Be    ${response_code}        ${response}

Verify Response Field Not Empty
    [Documentation]     Asserts that the given field in response is not empty.
    [Arguments]     ${response}         ${field}
    Should Not Be Empty    ${response.json()}[${field}]

Send Update Owner Request
    [Arguments]     ${body}
    ${update_owner_api_with_id}=       Format String    ${UPDATE_OWNER_API}     ${NEW_OWNER_ID}
    ${response}=     PUT On Session      ${ALIAS}       ${update_owner_api_with_id}         json=${body}
    RETURN      ${response}

Update User Via API
    [Documentation]     Updates owner city column by ID.
    ${body}=        Build Owner Body        ${OWNER_DETAILS}
    Set To Dictionary       ${body}     city=${UPDATED_CITY}
    ${response}=     Send Update Owner Request      ${body}
    RETURN      ${response}







