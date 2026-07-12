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

