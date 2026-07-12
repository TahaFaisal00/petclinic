*** Settings ***
Library         DatabaseLibrary
Resource        ../Resources/TestData.robot

*** Keywords ***
Open PetClinic Database Connection
    [Documentation]     Used as suite setup
    Connect To Database         ${DB_MODULE}          ${DB_NAME}         ${DB_USER}
    ...                         ${DB_PASS}          ${DB_HOST}      ${DB_PORT}

Close PetClinic Database Connection
    [Documentation]     Used as suite teardown
    Disconnect From Database

Owner Row Should Exist By Telephone
    [Documentation]     Proves the new owner row has been added in the
    ...                 database. Retry the assertion because of the
    ...                 commit lag after an api write.
    [Arguments]         ${telephone}
    Check Row Count
    ...                  SELECT id FROM owners WHERE telephone = %s
    ...                  equal      ${1}
    ...                  parameters=${{ ($telephone,) }}
    ...                  retry_timeout=5 seconds        retry_pause=0.5 seconds

Get Owner City By Telephone
    [Documentation]     Gets the city column of the owner with the given telephone from the database
    ...                 Used to asserts a persisted value.
    [Arguments]     ${telephone}
    ${row}=     Query    SELECT city FROM owners WHERE telephone = %s       parameters=${{ ($telephone,) }}
    RETURN      ${row}[0][0]

Owner City In Database Should Be
    [Documentation]     Asserts the owner city value in database by comparing it to the given city.
    [Arguments]     ${telephone}        ${expected_city}
    ${persisted_city}=      Get Owner City By Telephone     ${telephone}
    Should Be Equal    ${persisted_city}    ${expected_city}
