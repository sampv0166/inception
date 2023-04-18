FROM debian:buster

ARG DOMAIN_NAME

# install nginx and openssl
RUN apt update -y && \
	apt install -y nginx openssl

# make ssl directory and request for a self-signed certificate
# generate a new RSA key with 2048 bit length

RUN mkdir /etc/nginx/ssl && \
	openssl req -x509 -newkey rsa:2048 -days 365 -nodes \
		-keyout /etc/nginx/ssl/certificate.key \
		-out /etc/nginx/ssl/certificate.crt \
		-subj "/CN=AE"

#  sited_enabled folder is used to store configurations files for nginx that are active and served
COPY ./conf/default.conf /etc/nginx/sites-enabled/default 

RUN mv /etc/nginx/fastcgi_params /etc/nginx/default_fastcgi_params

COPY ./conf/fastcgi_params /etc/nginx/fastcgi_params

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]


# rsa = rivest-shamir-adlerman encryption algorithm
# the default command to run when the container is started .
# the command start the nginx server and using -g flag we can pass a configuration -
# directive (daemon off) to nginx process to keep it running untill the container is stopped or terminated

# https://stackoverflow.com/questions/41303885/nginx-do-i-really-need-sites-available-and-sites-enabled-folders

# openssl s_client -connect example.com:443 -tls1_3
