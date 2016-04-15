FROM ruby:latest

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# For capybara-webkit
RUN apt-get install -y libqt4-webkit libqt4-dev xvfb
RUN apt-get install -y vim

ENV APP_DIR /app
RUN mkdir $APP_DIR
WORKDIR $APP_DIR
ADD Gemfile $APP_DIR/Gemfile
ADD Gemfile.lock $APP_DIR/Gemfile.lock
RUN bundle install
ADD . $APP_DIR
