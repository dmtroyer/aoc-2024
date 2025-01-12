FROM ruby:3.3 AS builder

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && \
    gem update --system 3.6.2 && \
    bundle install
