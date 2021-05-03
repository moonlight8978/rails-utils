FROM ruby:3.0.1-alpine3.13

RUN apk add --no-cache git

RUN gem install bundler

COPY Gemfile Gemfile.lock
ARG SKIP_BUNDLER
ENV SKIP_BUNDLER $SKIP_BUNDLER
RUN if [[ -z "$SKIP_BUNDLER" ]] ; then bundle install ; fi
