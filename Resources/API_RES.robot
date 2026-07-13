*** Settings ***
Library         RequestsLibrary
Library         FakerLibrary
Library         String
Library         Collections
Library    DateTime
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
    ${response}=        POST On Session     ${ALIAS}        ${CREATE_OWNER_API}     json=${body}        expected_status=anything
    RETURN      ${response}

Create Owner Via API
    [Documentation]     Create a new owner by using a fresh details. can be used for test Setup.
    ...                 Publishes $NEW_OWNER_ID and $OWNER_DETAILS to a test scope.
    ${owner}=            Create Owner Details
    VAR         &{OWNER_DETAILS}        &{owner}        scope=test
    ${body}=        Build Owner Body     ${owner}
    ${response}=        Send Create Owner request       ${body}
    VAR        ${NEW_OWNER_ID}            ${response.json()}[id]       scope=TEST
    RETURN            ${response}

Attempt Create Owner With Missing Required Field Via API
    [Documentation]     Create a new owner without first name field. Used For Negative tests.
    ${owner}=            Create Owner Details
    VAR         &{OWNER_DETAILS}        &{owner}        scope=test
    ${body}=        Build Owner Body     ${owner}
    Remove From Dictionary    ${body}       firstName
    ${response}=        Send Create Owner request       ${body}
    RETURN            ${response}

Send Delete Owner Request
    ${delete_owner_api_with_id}=        Format String    ${DELETE_OWNER_API}     ${NEW_OWNER_ID}
    ${response}     DELETE On Session       ${ALIAS}      ${delete_owner_api_with_id}      expected_status=anything
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

Verify Response Field Contains
    [Documentation]     Asserts the response field contain the expected value.
    [Arguments]          ${response}      ${field}      ${message}
    Should Contain    ${response.json()}[${field}]    ${message}

Verify Response Contain
    [Documentation]     Asserts that the response contain the given value.
    [Arguments]      ${response}           ${message}
    Should Contain    ${response.text}    ${message}

Send Update Owner Request
    [Arguments]     ${body}
    ${update_owner_api_with_id}=       Format String    ${UPDATE_OWNER_API}     ${NEW_OWNER_ID}
    ${response}=     PUT On Session      ${ALIAS}       ${update_owner_api_with_id}         json=${body}
    RETURN      ${response}

Update Owner Via API
    [Documentation]     Updates owner city column by ID.
    ${body}=        Build Owner Body        ${OWNER_DETAILS}
    Set To Dictionary       ${body}     city=${UPDATED_CITY}
    ${response}=     Send Update Owner Request      ${body}
    RETURN      ${response}

Build Pet Body
    [Arguments]    ${pet_type_name}       ${pet_type_id}
    ${fake_birth_date}=     FakerLibrary.Date Of Birth                  maximum_age=25
    ${fake_birth_date}=     Convert Date        ${fake_birth_date}      result_format=%Y-%m-%d
    ${fake_name}=           FakerLibrary.First Name
    ${type}     Create Dictionary         name=${pet_type_name}        id=${pet_type_id}
    ${body}=        Create Dictionary       name=${fake_name}       birthDate=${fake_birth_date}           type=${type}
    RETURN      ${body}

Send Add Pet Request
    [Arguments]     ${body}
    ${add_pet_to_owner_api_with_id}=        Format String    ${ADD_PET_TO_OWNER_API}     ${NEW_OWNER_ID}
    ${response}=     POST On Session     ${ALIAS}         ${add_pet_to_owner_api_with_id}     json=${body}
    RETURN      ${response}

Add Pet To Owner Via API
    [Documentation]     Create a new pet for the newly created owner. Publishes $PET_ID to a test scope.
    ${body}=        Build Pet Body     ${CAT_TYPE_NAME}        ${CAT_TYPE_ID}
    ${response}=       Send Add Pet Request        ${body}
    VAR     ${PET_ID}       ${response.json()}[id]      scope=TEST
    RETURN      ${response}

Send Delete Pet Request
    ${delete_pet_api_with_pet_id}=      Format String    ${DELETE_PET_API}      ${PET_ID}
    ${response}=    DELETE On Session       ${ALIAS}         ${delete_pet_api_with_pet_id}
    RETURN      ${response}

Delete Pet Via API
    [Documentation]     Deletes a pet by pet ID
    ${response}=        Send Delete Pet Request
    RETURN      ${response}

Build Create Vet Visit Body
    ${body}=     Create Dictionary        date=${VET_VISIT_DATE}       description=${VET_VISIT_DESCRIPTION}
    RETURN      ${body}

Send Create Vet Visit Request
    [Arguments]     ${body}
    ${add_vet_visit_api_with_ids}=        Format String    ${ADD_VET_VISIT_API}     ${NEW_OWNER_ID}     ${PET_ID}
    ${response}=     POST On Session     ${ALIAS}        ${add_vet_visit_api_with_ids}         json=${body}
    RETURN      ${response}

Create Vet Visit Via API
    [Documentation]     Creates a vet visit for the pet of an owner.
    ${body}=        Build Create Vet Visit Body
    ${response}=        Send Create Vet Visit Request       ${body}
    RETURN      ${response}

