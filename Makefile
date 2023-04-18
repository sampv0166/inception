FILE			= ./srcs/docker-compose.yml
DOCKER_CMD		= docker compose -f ${FILE}

NGINX_CNTNR		= nginx
MARIA_CNTNR		= mariadb
WRDPR_CNTNR		= wordpress

NGINX_IMAGE		= nginx:custom
MARIA_IMAGE		= mariadb:custom
WRDPR_IMAGE		= wordpress:custom

NETWORK			= custom
WP_VOLUME 		= wordpress_data
DB_VOLUME 		= mariadb_data

VOLUME_DIR 		= /home/apila-va/data
WP_VOLUME_DIR	= ${VOLUME_DIR}/wordpress
DB_VOLUME_DIR	= ${VOLUME_DIR}/database

all: build up

build:
	${DOCKER_CMD} build

up:
	${DOCKER_CMD} up

down:
	${DOCKER_CMD} down

create_volumes:
	sudo mkdir -p ${WP_VOLUME_DIR} ${DB_VOLUME_DIR}

goin_nginx:
	docker exec -it ${NGINX_CNTNR} /bin/bash  

goin_mariadb:
	docker exec -it ${MARIA_CNTNR} /bin/bash

goin_wordpress:
	docker exec -it ${WRDPR_CNTNR} /bin/bash

clean:
	docker rm -f ${NGINX_CNTNR} ${MARIA_CNTNR} ${WRDPR_CNTNR}
	docker rmi -f ${NGINX_IMAGE} ${MARIA_IMAGE} ${WRDPR_IMAGE}
	docker volume rm -f ${WP_VOLUME} ${DB_VOLUME}
	sudo rm -rf ${WP_VOLUME_DIR}/* ${DB_VOLUME_DIR}/*
	if docker network inspect ${NETWORK}; then \
        docker network rm ${NETWORK}; \
    fi

re: clean all

# docker compose -f			====> RUN DOCKER COMPOSE WITH THE SPECIFIED FILE NAME
# docker rm -f				====> REMOVE CONTAINER FORCEFULLY 
# docker rmi -f				====> REMOVE DOCKER IMAGES FORCEFULLY 
# volume rm -f				====> REMOVE SPECIFIED VOLUMES FROM DOCKER VOLEUME STORE FORCEFULLY 

# docker compose -f build	====> BUILD ALL DOCKER IMAGES IN THE SPECIFIED docker.yml file
# docker compose -f up		====> START ALL DOCKER CONTAINER IN THE SPECIFIED docker.yml file
# docker compose -f down	====> STOPS AND REMOVES ALL DOCKER CONTAINER IN THE SPECIFIED docker.yml file

# docker exec -it <container_name> /bin/bash		====>  open a bash shell in the specified container in interactive mode
# docker network inspect ${NETWORK}					====> search to find the specified network.
#  docker network rm <network_name> 				====> remove the specifed docker network