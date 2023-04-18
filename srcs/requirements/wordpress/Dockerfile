FROM debian:buster

ARG WP_CLI_SRC=https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
ARG WP_CLI_DOC=wp-cli.phar
ARG WP_FILE_SRC=https://wordpress.org/latest.tar.gz
ARG WP_FILE_DOC=latest.tar.gz

RUN apt update -y && \
	apt install -y \
	php php-fpm php-mysqli \
	wget mariadb-client sendmail

# this directory is needed to store PID file which FPM uses to track the php processess
RUN mkdir -p /run/php  && mkdir -p /var/www/html

# change the defauult www.conf file for php-fpm to listen to port 9000 .
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

# get wordpress cli and set execute permission to the file
# move the cli file to a global directory so that we can use wp command from anywhere in the system 
RUN wget ${WP_CLI_SRC} && \
	chmod +x ${WP_CLI_DOC} && \
	mv ${WP_CLI_DOC} /usr/local/bin/wp

WORKDIR /var/www/html

RUN wget ${WP_FILE_SRC} && \
	tar xzvf ${WP_FILE_DOC} --strip-components=1

# Change the owner of the current directory and sub-directories to www-data .
# www-data is user and group that the webserver runs
RUN chown -R www-data:www-data . && chmod -R 775 .

# Set up WP for entrypoint for php-requests
EXPOSE 9000

COPY ./tools/entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

# php-fpm = fast CGI (common gateway interface) for php used to run php scripts
# php-mysqli = php module used to communicate with mysql databses
# wget = is a command line tool that can be used to download the latest wordpress software
# mariadb client = allows to connect to mariadb server

# "x" stands for extract
# "z" stands for gunzip (decompress)
# "v" stands for verbose (show the files being extracted)
# "f" stands for file (specify the filename of the archive)
# -R apply the changes recursively to all directory files and subdirectories


# PHP-FPM is a process manager for PHP that allows you to run PHP code as a separate process 
# from the web server. This provides better performance and stability for PHP applications, 
# especially in high-traffic environments.
