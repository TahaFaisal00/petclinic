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

Delete Owner With Pet Should Be Rejected And Not Cascade
    [Documentation]     Creates a new Owner via API Then creates a new pet for this owner via API
    ...                 and asserts the status codes and response messages of each and their existence in Database.
    ...                 Delete the owner (that have a pet) and asserts that the delete will be rejected and won't
    ...                 cascade. The two rows won't be removed from the DB.
    ...                 NOTE: This asserts current behavior. Owner+pet deletion rejection is incosistent with
    ...                 pet+visit cascade. tracked as a bug but asserted as it is to keep CI green.
    ${response}=        Create Owner Via API
    Verify Response Code        ${response}     ${CREATED_CODE}
    Verify Response Field Not Empty    ${response}    ${FIRST_NAME_FIELD_RESPONSE_MESSAGE}
    Owner Row Should Exist By Telephone         ${OWNER_DETAILS.telephone}
    ${response}=        Add Pet To Owner Via API
    Verify Response Code        ${response}     ${CREATED_CODE}
    Verify Response Field Not Empty    ${response}    ${NAME_FIELD_RESPONSE_MESSAGE}
    Pet Row Should Exist By Pet ID And Owner ID       ${PET_ID}       ${NEW_OWNER_ID}
    ${response}=        Delete Owner Via API
    Verify Response Code    ${response}    ${NOT_FOUND_CODE}
    Verify Response Field Contains      ${response}     ${DETAIL_FIELD_RESPONSE_MESSAGE}    ${DATA_CONSTRAINT_VIOLATION_MESSAGE}
    Verify Response Field Contains      ${response}     ${TITLE_FIELD_RESPONSE_MESSAGE}     ${DATA_INTEGRITY_VIOLATION_EXCEPTION_MESSAGE}
    Owner Row Should Exist By Telephone         ${OWNER_DETAILS.telephone}
    Pet Row Should Exist By Pet ID And Owner ID       ${PET_ID}       ${NEW_OWNER_ID}
    [Teardown]    Run Keywords
    ...           Run Keyword And Ignore Error        Delete Pet Via API    AND
    ...           Run Keyword And Ignore Error        Delete Owner Via API

