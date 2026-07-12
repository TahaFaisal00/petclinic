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

${FIRST_NAME_FIELD_RESPONSE_MESSAGE}         firstName

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


