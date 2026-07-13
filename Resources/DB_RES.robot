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

Owner Row Should Not Exist By Telephone
    [Documentation]     Proves the new owner row has been removed from the
    ...                 database.
    [Arguments]         ${telephone}
    Check Row Count
    ...                  SELECT id FROM owners WHERE telephone = %s
    ...                  equal      ${0}
    ...                  parameters=${{ ($telephone,) }}


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

Get Owner First Name By Telephone
    [Documentation]     Gets the first_name column of an owner with given telephone from the database
    ...                 Used to asserts a persisted value.
    [Arguments]     ${telephone}
    ${row}=       Query    SELECT first_name FROM owners WHERE telephone = %s        parameters=${{ ($telephone,) }}
    RETURN      ${row}[0][0]

Owner First Name In Database Should Be
    [Documentation]     Asserts the owner city value in database by comparing it to the given city.
    [Arguments]     ${telephone}        ${expected_city}
    ${persisted_first_name}=      Get Owner First Name By Telephone     ${telephone}
    Should Be Equal    ${persisted_first_name}    ${expected_city}


Pet Row Should Exist By Pet ID And Owner ID
    [Documentation]     Proves the new pet row has been added in the
    ...                 database. Retry the assertion because of the
    ...                 commit lag after an api write.
    [Arguments]     ${pet_id}     ${owner_id}
    Check Row Count
    ...           SELECT id FROM pets WHERE id = %s AND owner_id = %s
    ...           equal     ${1}
    ...           parameters=${{ ($pet_id, $owner_id) }}
    ...           retry_timeout=5 seconds        retry_pause=0.5 seconds

Pet Row Should Not Exist By Pet ID And Owner ID
    [Documentation]     Proves the new pet row has been removed from the
    ...                 database.
    [Arguments]     ${pet_id}     ${owner_id}
    Check Row Count
    ...           SELECT id FROM pets WHERE id = %s AND owner_id = %s
    ...           equal     ${0}
    ...           parameters=${{ ($pet_id, $owner_id) }}


Vet Visit Row Should Exist By Description And Pet ID
    [Documentation]     Proves the new vet visit row has been added in the
    ...                 database. Retry the assertion because of the
    ...                 commit lag after an api write.
    [Arguments]         ${description}      ${pet_id}
    Check Row Count
    ...           SELECT id FROM visits WHERE description = %s AND pet_id = %s
    ...           equal     ${1}
    ...           parameters=${{ ($description,$pet_id) }}
    ...           retry_timeout=5 seconds        retry_pause=0.5 seconds

Vet Visit Row Should Not Exist By Description And Pet ID
    [Documentation]     Proves the new vet visit row has been removed from the
    ...                 database.
    [Arguments]         ${description}      ${pet_id}
    Check Row Count
    ...           SELECT id FROM visits WHERE description = %s AND pet_id = %s
    ...           equal     ${0}
    ...           parameters=${{ ($description,$pet_id) }}

Get Owner Rows Count 
    [Documentation]     Get the owners table rows count from the database.
    ${rows_count}=      Query    SELECT COUNT(*) FROM owners
    RETURN          ${rows_count}[0][0]

Verify Rows Count Is Unchanged
    [Documentation]
    [Arguments]     ${old_rows_count}       ${new_rows_count}
    Should Be Equal As Strings    ${old_rows_count}    ${new_rows_count}
