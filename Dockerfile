FROM debian:sid-slim
MAINTAINER Jean-Avit Promis "docker@katagena.com"
LABEL org.label-schema.vcs-url="https://github.com/nouchka/docker-heroku"
LABEL version="latest"

RUN apt-get update --fix-missing && \
	apt-get update && \
	apt-get install -y -q php php-mysql php-json php-fpm php-xml php-mbstring php-curl apache2 libapache2-mod-php sudo curl unzip git wget && \
	ln -s /usr/sbin/php7.3-fpm /usr/sbin/php-fpm && \
	ln -s /usr/sbin/apache2 /usr/sbin/httpd

RUN wget https://getcomposer.org/installer -O - -q | php -- --install-dir=/usr/local/bin --filename=composer && \
	curl https://cli-assets.heroku.com/install.sh | sh

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/developer

WORKDIR /home/developer/workspace/

RUN a2enmod proxy_fcgi
USER developer
RUN /usr/local/bin/heroku update
USER root

COPY heroku-wrap /heroku-wrap
RUN chmod +x /heroku-wrap

ENV APACHE_RUN_USER=www-data \
	APACHE_RUN_GROUP=www-data \
	APACHE_LOG_DIR=/var/log/apache2 \
	APACHE_LOCK_DIR=/var/lock/apache2 \
	APACHE_RUN_DIR=/var/run/apache2 \
	APACHE_PID_FILE=/var/run/apache2/apache2.pid


ENTRYPOINT [ "/heroku-wrap" ]
