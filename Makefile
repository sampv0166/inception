DOCKER_FILE			= ./srcs/docker-compose.yml
DOCKER_CMD			= docker compose -f ${FILE}

NGINX_CONTAINER = nginx

NGINX_IMAGE = nginx:custom

all: build up

build:
		${DOCKER_CMD} build
up:
		${DOCKER_CMD} up
down:	
		${DOCKER_CMD} down
clean:
		docker rm -f ${NGINX_CONTAINER}

re: clean all