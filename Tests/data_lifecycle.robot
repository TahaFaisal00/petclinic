*** Settings ***
Resource            ../Resources/API_RES.robot
Resource            ../Resources/DB_RES.robot
Suite Setup         Run Keywords     Open Session            Open PetClinic Database Connection
Suite Teardown      Close PetClinic Database Connection

*** Test Cases ***
Fixture Data Should Have Valid Referential Integrity
    [Documentation]     Verifies every foreign key in the Database tables: no orphaned pets, pet-types, visits,
    ...                 or in the junction table of vet specialties.
    Pets Should Have No Orphaned Owner References
    Pets Should Have No Orphaned Types References
    Vet Visits Should Have No Orphaned Pet References
    Vet Specialties Should Have No Orphaned Vets Or Specialties References

Fixture Data Should Match Expected Baseline
    [Documentation]     Verifies the fixture data matches its known baseline both total record counts
    ...                 and specific expected content (owners per city, pets by name)
    ...                 guarding against data loss, duplication, or corruption.
    Verify Owners Table Rows Count
    Verify Pets Table Rows Count
    Verify Vets Table Rows Count
    Owners In Madison Count Should Be
    Pets Names Lucky Count Should Be
