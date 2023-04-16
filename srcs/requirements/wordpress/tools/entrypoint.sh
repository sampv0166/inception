#! /bin/bash

# Download wordpress:
# https://wordpress.org/documentation/article/how-to-install-wordpress/
# https://wordpress.org/documentation/article/creating-database-for-wordpress/
# https://www.cloudways.com/blog/install-wordpress-using-wp-cli/
# https://make.wordpress.org/cli/handbook/how-to/how-to-install/
# https://wordpress.org/documentation/article/how-to-install-wordpress/

#sleep ${SLEEP_TIME}	# To ensure that mysql is running

# p-config.php is a configuration file used by WordPress to define its database connection, 
# installation path, security keys, and other important settings. It is required for the correct 
# functioning of WordPress and is automatically generated during the installation process. 
# Without it, WordPress would not be able to access its database, which means that it wouldn't be 
# able to store and retrieve data such as posts, pages, and user information. In addition, the 
# security keys defined in the wp-config.php file are used to encrypt user data and to ensure 
# that WordPress is secure from external attacks.

if [ -f "wp-config.php" ]; then	
	echo "WordPress: already installed"
else
	echo "WordPress: creating config file"
	wp config create --allow-root \
		--dbname=${MYSQL_NAME} \
		--dbuser=${MYSQL_USER} \
		--dbpass=${MYSQL_PASSWORD} \
		--dbhost=${MYSQL_HOST}

	echo "WordPress: installing"

	wp core install --allow-root \
		--url=${WP_URL} \
		--title=${WP_TITLE} \
		--admin_user=${WP_ADMIN_NAME} \
		--admin_password=${WP_ADMIN_PASSWORD} \
		--admin_email=${WP_ADMIN_EMAIL}

	echo "WordPress: creating user"
	wp user create --allow-root \
		${WP_USER_NAME} ${WP_USER_EMAIL} \
		--role=${WP_USER_ROLE} \
		--user_pass=${WP_USER_PASSWORD}
	# change thw owner of the directory to the specified user:group to make sure that server 
    # has access the files in the var/www/html directory
	chown -R www-data:www-data /var/www/html
	# set read write and execute permision
	chmod -R 775 /var/www/html
	# The g+w option is giving the group write permission, 
    # so any user in the www-data group can write to the files in the directory.
	chmod -R g+w /var/www/html
fi

#/usr/sbin/php-fpm7.3 -R -F is a command that starts the PHP-FPM (FastCGI Process Manager)
# service with the configuration specified in the /etc/php/7.3/fpm/php-fpm.conf file.
# The -R option causes PHP-FPM to run in foreground mode and print the logs to the console. 
# The -F option prevents the service from running in daemon mode, which is useful when running 
# the service inside a Docker container.

# PHP-FPM is a process manager for PHP that allows you to run PHP code as a separate process 
# from the web server. This provides better performance and stability for PHP applications, 
# especially in high-traffic environments.


/usr/sbin/php-fpm7.3 -R -F