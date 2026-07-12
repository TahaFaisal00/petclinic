*** Variables ***
${BASE_URL}     http://localhost:9966/petclinic
${ALIAS}        Pet
${CREATE_OWNER_API}         /api/owners
${DELETE_OWNER_API}         /api/owners/{}
${UPDATE_OWNER_API}         /api/owners/{}

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

