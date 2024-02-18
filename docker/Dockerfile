FROM ruby:3-alpine3.17 as builder

COPY docker/Gemfile ./

RUN apk add --update --no-cache make ruby-dev gcc musl-dev && \
    gem install bundler --user-install && \
    bundle install --no-cache && \
    apk del gcc make musl-dev ruby-dev && \
    rm -rf /usr/local/bundle/cache /root/.bundle

FROM ruby:3-alpine3.17 as runtime

WORKDIR /deploy
COPY . .
RUN mv docker/Gemfile ./

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
RUN apk add --update --no-cache openssh-client && \
    bundle exec cap --version && \
    ssh-keyscan github.com

RUN chmod +x docker/launcher.sh

ENTRYPOINT [ "docker/launcher.sh" ]