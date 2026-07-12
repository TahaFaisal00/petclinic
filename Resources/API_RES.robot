*** Settings ***
Library         RequestsLibrary
Library         FakerLibrary
Library         String
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
    ...                     city=${faker_city}       phone_number=${faker_telephone}
    RETURN           ${OWNER_DETAILS}

