FROM debian:buster

ARG SLEEP_TIME
ARG MYSQL_NAME
ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG MYSQL_ROOT_PASSWORD

RUN apt update -y && \
	apt install procps mariadb-server -y && \
    apt -y autoremove && \
    apt -y clean && \
    rm -rf /var/lib/apt/lists/*

# Adjust the mysql configuration to listen to all ip addresses
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod o-w /etc/mysql/mariadb.conf.d/50-server.cnf

# Run mysql and create database along with users
RUN service mysql start && sleep ${SLEEP_TIME} && \
	mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_NAME}; \
	CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'; \
	GRANT ALL PRIVILEGES ON ${MYSQL_NAME}.* TO '${MYSQL_USER}'@'%'; \
	UPDATE mysql.user SET host='%' WHERE user='root'; \
	ALTER USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; \
	FLUSH PRIVILEGES;"

EXPOSE 3306
 
ENTRYPOINT [ "mysqld" ]



# '@'% user can connect from any host
# .* grant privilages to all tables in the databas
# update mysql.user toable hosts to all hosts to let the root user connect from any host
# alter the password of the root user. specifies the username and host of the user 
# account that will have its password changed
# when user acccounts are modified we need to flush the sql server memmoery for the changes 
# to be in effect immediately