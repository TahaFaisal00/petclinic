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
