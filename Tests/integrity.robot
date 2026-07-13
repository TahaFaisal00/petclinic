*** Settings ***
Resource            ../Resources/API_RES.robot
Resource            ../Resources/DB_RES.robot
Suite Setup         Run Keywords     Open Session            Open PetClinic Database Connection
Suite Teardown      Close PetClinic Database Connection

*** Test Cases ***

Delete Pet With Visit Should Cascade Remove Visit In Database
    [Documentation]     Creates a new Owner via API Then creates a new pet for this owner via API
    ...                 then creates a vet visit for this pet and asserts the status codes and response messages of each
    ...                 and their existence in Database. Delete the Pet (that have a visit) and asserts that
    ...                 the delete will cascade and remove the visit alongside the pet without leaving an orphan row.
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
    ${response}=        Delete Pet Via API
    Verify Response Code    ${response}    ${NO_CONTENT_CODE}
    Pet Row Should Not Exist By Pet ID And Owner ID                 ${PET_ID}       ${NEW_OWNER_ID}
    Vet Visit Row Should Not Exist By Description And Pet ID        ${VET_VISIT_DESCRIPTION}      ${PET_ID}
    [Teardown]    Run Keywords
    ...           Run Keyword And Ignore Error        Delete Pet Via API    AND
    ...           Run Keyword And Ignore Error        Delete Owner Via API