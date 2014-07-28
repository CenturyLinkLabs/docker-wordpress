FROM centurylinklabs/apache-php:latest
MAINTAINER CentruyLinkLabs

# Install packages
RUN apt-get update && \
 DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
 DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor pwgen && \
 apt-get -y install mysql-client

# Download latest version of Wordpress into /app
RUN rm -fr /app && \ 
 git clone https://github.com/WordPress/WordPress.git /app 

# Add wp-config with info for Wordpress to connect to DB
ADD wp-config.php /app/wp-config.php
RUN chmod 644 /app/wp-config.php

# Add script to create 'wordpress' DB
ADD run.sh run.sh
RUN chmod 755 /*.sh

EXPOSE 80
CMD ["/run.sh"]
