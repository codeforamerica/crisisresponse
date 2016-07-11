FROM ruby:latest

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# Javascript runtime
RUN apt-get install -y nodejs

ENV PHANTOM_PACKAGE phantomjs-2.1.1-linux-x86_64
ADD https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_PACKAGE.tar.bz2 .
RUN tar -xjf $PHANTOM_PACKAGE.tar.bz2 &&\
      mv $PHANTOM_PACKAGE/bin/phantomjs /bin/phantomjs &&\
      rm -r $PHANTOM_PACKAGE $PHANTOM_PACKAGE.tar.bz2

ENV APP_DIR /app
RUN mkdir $APP_DIR
WORKDIR $APP_DIR

ADD Gemfile* $APP_DIR/
ENV BUNDLE_PATH /box/bundle
RUN bundle install
