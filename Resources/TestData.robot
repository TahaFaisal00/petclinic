*** Variables ***
${BASE_URL}     http://localhost:9966/petclinic
${ALIAS}        Pet
${CREATE_OWNER_API}         /api/owners
${DELETE_OWNER_API}         /api/owners/{}
${UPDATE_OWNER_API}         /api/owners/{}
${ADD_PET_TO_OWNER_API}     /api/owners/{}/pets
${DELETE_PET_API}           /api/pets/{}
${ADD_VET_VISIT_API}        /api/owners/{}/pets/{}/visits

${CREATED_CODE}                             201
${NO_CONTENT_CODE}                          204
${NOT_FOUND_CODE}                           404
${BAD_REQUEST_CODE}                         400


${FIRST_NAME_FIELD_RESPONSE_MESSAGE}         firstName
${NAME_FIELD_RESPONSE_MESSAGE}               name
${DESCRIPTION_FIELD_RESPONSE_MESSAGE}        description
${DETAIL_FIELD_RESPONSE_MESSAGE}             detail
${TITLE_FIELD_RESPONSE_MESSAGE}              title

${DATA_CONSTRAINT_VIOLATION_MESSAGE}         The requested resource could not be processed due to a data constraint violation
${DATA_INTEGRITY_VIOLATION_EXCEPTION_MESSAGE}     DataIntegrityViolationException
${INVALID_OR_MISSING_PARAMETERS_MESSAGE}            The request contains invalid or missing parameters
${FIELD_FIRST_NAME_MUST_NOT_BE_NULL_MESSAGE}        Field 'firstName' must not be null
${FIELD_TELEPHONE_MUST_MATCH_SPECS_MESSAGE}         Field 'telephone' must match
${DB_MODULE}            pymysql
${DB_NAME}              petclinic
${DB_USER}              petclinic
${DB_PASS}              petclinic
${DB_HOST}              %{DB_HOST=127.0.0.1}
${DB_PORT}              ${3306}

${UPDATED_CITY}         Basra

${CAT_TYPE_ID}          ${1}
${CAT_TYPE_NAME}        cat

${VET_VISIT_DESCRIPTION}       rabies shot
${VET_VISIT_DATE}              2013-01-01

${INVALID_TELEPHONE_VALUE}      xxxxxxxxxxxxxx


