FROM ruby:2.4.4-alpine
LABEL maintainer="Jason Raimondi <jason@raimondi.us>"

WORKDIR /app

RUN apk update && apk add --update --no-cache ruby-dev build-base dcron supervisor

COPY app/Gemfile* /app/

RUN bundle install --jobs=3

COPY app /app/

COPY container/crontab.txt /app/crontab.txt
COPY container/scripts/docker-entrypoint.sh /docker-entrypoint.sh
COPY container/supervisor.d /etc/supervisor.d

RUN chmod +x /docker-entrypoint.sh \
    && /usr/bin/crontab /app/crontab.txt \
    && mkdir -p /var/logs/twitter-cleaner

ENTRYPOINT ["supervisord"]
CMD ["--nodaemon", "--configuration", "/etc/supervisord.conf"]
