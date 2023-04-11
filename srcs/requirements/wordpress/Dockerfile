FROM debian:buster

ARG WP_CLI_SRC=https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
ARG WP_CLI_DOC=wp-cli.phar
ARG WP_FILE_SRC=https://wordpress.org/latest.tar.gz
ARG WP_FILE_DOC=latest.tar.gz


# udpate the package repository 
# install
# php
# php-fpm = fast CGI (common gateway interface) for php used to run php scripts
# php-mysqli = php module used to communicate with mysql databses
# wget = is a command line tool that can be used to download the latest wordpress software
# mariadb client = allows to connect to mariadb server
# remove packages that were installed as dependencies and no londer needed
# remove downloaded packges
# remove cached data to reduce the image size


RUN apt update -y && \
	apt install -y \
		php php-fpm php-mysqli \
		wget mariadb-client && \
    apt -y autoremove && \
    apt -y clean && \
    rm -rf /var/lib/apt/lists/*

# first directory is used to store PID file which can be used to track the php process
# second directory is the default web root directory for nginx.all website files can be stored here

RUN mkdir -p /run/php && mkdir -p /var/www/html

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

# get wordpress cli and set execute permission to the file
# move the cli file to global directory so that we can use wp command from anywhere in the system 
RUN wget ${WP_CLI_SRC} && \
	chmod +x ${WP_CLI_DOC} && \
	mv ${WP_CLI_DOC} /usr/local/bin/wp

# Change the working directory
WORKDIR /var/www/html

# download wordpress files from the link and saves it to the current wowrking directory
# extract the files using the tar command , --strip components us used to remove the top level directory -
# and place the files directly in to the current working directory
# "x" stands for extract
# "z" stands for gunzip (decompress)
# "v" stands for verbose (show the files being extracted)
# "f" stands for file (specify the filename of the archive)
RUN wget ${WP_FILE_SRC} && \
	tar xzvf ${WP_FILE_DOC} --strip-components=1 && \
	rm -rf ${WP_FILE_DOC}

# Change the owner of the current directory and sub-directories  to www-data .
#  www-data is user and group that the webserver typically runs in linux distros
# this commadn ensures that the web server has necessory permissions to access and modify the files-
# in the directory
RUN chown -R www-data:www-data . && chmod -R 775 .

# Set up WP for entrypoint
EXPOSE 9000
#  copy the entrypoint file to usr/local/bin so that i can run the script from anywhere
COPY ./tools/entrypoint.sh /usr/local/bin/
#  sets the execute permission the entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]