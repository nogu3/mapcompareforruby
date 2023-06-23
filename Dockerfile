FROM ruby:3.2.2

WORKDIR /home/workspace
RUN mkdir src && cd ./src
COPY ./src/Gemfile .

RUN bundle install