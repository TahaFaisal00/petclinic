*** Variables ***
${BASE_URL}     http://localhost:9966/petclinic
${ALIAS}        Pet
${CREATE_OWNER_API}         /api/owners
${DELETE_OWNER_API}         /api/owners/{}

${DB_MODULE}            pymysql
${DB_NAME}              petclinic
${DB_USER}              petclinic
${DB_PASS}              petclinic
${DB_HOST}              %{DB_HOST=127.0.0.1}
${DB_PORT}              ${3306}
