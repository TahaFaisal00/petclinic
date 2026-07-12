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
    [Arguments]         ${owner}
    Check Row Count
    ...                  SELECT id FROM owners WHERE telephone = %s
    ...                  equal      ${1}
    ...                  parameters=${{ ($owner,) }}
    ...                  retry_timeout=5 seconds        retry_pause=0.5 seconds
