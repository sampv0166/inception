FROM debian:buster

ARG DOMAIN_NAME

# install nginx and openssl
RUN apt update -y && \
	apt install -y nginx openssl && \
    apt -y autoremove && \
    apt -y clean && \
    rm -rf /var/lib/apt/lists/*

# make ssl directory and request for a self-signed certificate
# generate a new RSA key with 2048 bit length
# save the key ssl folder
# save the certificate to ssl folder
RUN mkdir /etc/nginx/ssl && \
	openssl req -x509 -newkey rsa:2048 -days 365 -nodes \
		-keyout /etc/nginx/ssl/certificate.key \
		-out /etc/nginx/ssl/certificate.crt \
		-subj "/CN=AE/ST=AbuDhabi/O=apila-va/CN=localhost"

COPY ./conf/default.conf /etc/nginx/sites-enabled/default

RUN mv /etc/nginx/fastcgi_params /etc/nginx/default_fastcgi_params

COPY ./conf/fastcgi_params /etc/nginx/fastcgi_params

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]


# CN(-subj) - sets the COMMONNAME field to localhost which represents the identity who uses the certificate
# rsa = rivest-shamir-adlerman encryption algorithm
# -p stand for create parent directories if they dont exist

# CMD
# the default command to run when the container is started .
# the command start the nginx server and using -g flag we can pass a configuration -
# directive (daemon off) to nginx process to keep it running untill the container is stopped or terminated

