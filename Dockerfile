FROM ruby:2.4.4-alpine
LABEL maintainer="Jason Raimondi <jason@raimondi.us>"

WORKDIR /app

RUN apk update && apk add --update --no-cache ruby-dev build-base dcron

COPY app/Gemfile /app/Gemfile

RUN bundle install --jobs=3

ADD app /app

ADD crontab.txt /app/crontab.txt
ADD scripts/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh \
    && /usr/bin/crontab /app/crontab.txt

ENTRYPOINT /docker-entrypoint.sh

CMD ["/usr/sbin/crond", "-f", "-l", "8"]
