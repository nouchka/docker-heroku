FROM debian:jessie
MAINTAINER Jean-Avit Promis "docker@katagena.com"
LABEL org.label-schema.vcs-url="https://github.com/nouchka/docker-heroku"
LABEL version="latest"

RUN apt-get update --fix-missing && \
	apt-get update && \
	apt-get install -y -q git wget php5 php5-mysql php5-fpm

RUN wget https://getcomposer.org/installer -O - -q | php -- --install-dir=/usr/local/bin --filename=composer

RUN wget https://cli-assets.heroku.com/branches/stable/heroku-linux-amd64.tar.gz -O heroku.tar.gz && \
	tar -xvzf heroku.tar.gz -C /usr/local/lib && \
	/usr/local/lib/heroku/install && \
	/usr/local/bin/heroku version

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/developer

WORKDIR /home/developer/workspace/
USER developer

ENTRYPOINT [ "heroku" ]
