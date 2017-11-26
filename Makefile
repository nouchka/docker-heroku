prefix = /usr/local
install:; install bin/heroku $(prefix)/bin
test:; docker-compose -f docker-compose.test.yml build && heroku logs
