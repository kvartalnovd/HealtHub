PROJECT_NAME="HealthHub"

tag:
	./scripts/tag.sh

PROJECT_CORE_DOMAIN="healthub.ru"
PYTHON = "python3.12"

CONTAINER_RUNNER=docker
DOCKER_COMPOSE_DIRECTORY=./docker-compose.d
DOCKER_COMPOSE_FILE=${DOCKER_COMPOSE_DIRECTORY}/docker-compose.yml
DOCKER_COMPOSE_FILE_UWSGI=${DOCKER_COMPOSE_DIRECTORY}/docker-compose-uwsgi.yml
DOCKER_COMPOSE_FILE_TUNNEL=${DOCKER_COMPOSE_DIRECTORY}/docker-compose-ssh-tunnel.yml
DOCKER_COMPOSE_FILE_MOCK=${DOCKER_COMPOSE_DIRECTORY}/docker-compose-mock.yml


render-dev-configs-force:
	${DOCKER_COMPOSE_DIRECTORY}/render-dev-config.sh

render-dev-configs:
	test -f ${DOCKER_COMPOSE_DIRECTORY}/debug.d/config-dev.yml || ${DOCKER_COMPOSE_DIRECTORY}/render-dev-config.sh

compose-rmi:
	${CONTAINER_RUNNER} rmi -f `(${CONTAINER_RUNNER} images -f reference="${PROJECT_NAME}_*" -q)`

compose-build:
	${CONTAINER_RUNNER}-compose --project-name ${PROJECT_NAME} -f ${DOCKER_COMPOSE_FILE} -f ${DOCKER_COMPOSE_FILE_UWSGI} build

compose-up: render-dev-configs
	${CONTAINER_RUNNER}-compose --project-name ${PROJECT_NAME} -f ${DOCKER_COMPOSE_FILE} -f ${DOCKER_COMPOSE_FILE_UWSGI} -f ${DOCKER_COMPOSE_FILE_MOCK} up

compose-down:
	${CONTAINER_RUNNER}-compose --project-name ${PROJECT_NAME} -f ${DOCKER_COMPOSE_FILE} -f ${DOCKER_COMPOSE_FILE_UWSGI} -f ${DOCKER_COMPOSE_FILE_MOCK} down

compose-stop:
	${CONTAINER_RUNNER}-compose --project-name ${PROJECT_NAME} -f ${DOCKER_COMPOSE_FILE} -f ${DOCKER_COMPOSE_FILE_UWSGI} -f ${DOCKER_COMPOSE_FILE_MOCK} stop


compose-tunnel-up:
	${CONTAINER_RUNNER}-compose --project-name ${PROJECT_NAME} -f ${DOCKER_COMPOSE_FILE} -f ${DOCKER_COMPOSE_FILE_TUNNEL} up

compose-tunnel-down:
	${CONTAINER_RUNNER}-compose --project-name ${PROJECT_NAME} -f ${DOCKER_COMPOSE_FILE} -f ${DOCKER_COMPOSE_FILE_TUNNEL} down

compose-make-migrations:
	${CONTAINER_RUNNER} exec -it ${PROJECT_NAME}_webserver_1 ${PYTHON} /webserver/manage.py makemigrations

compose-migrate:
	${CONTAINER_RUNNER} exec -it ${PROJECT_NAME}_webserver_1 ${PYTHON} /webserver/manage.py migrate


compose-do-admin:
	bash -c "read -p \"Username: \" USERNAME ; echo \$$USERNAME; ${CONTAINER_RUNNER} exec -u postgres -it ${PROJECT_NAME}_db_1 psql -c \"update auth_user set is_staff = true, is_superuser = true where username = '\$$USERNAME';\" "

run-ssh-webserver-tunnel:
	sshpass -p  HealtHub  ssh -o "StrictHostKeyChecking=no"  -R 0.0.0.0:8081:127.0.0.1:8081 HealtHub@127.0.0.1 -p 2222

