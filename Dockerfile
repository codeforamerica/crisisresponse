FROM ruby:latest

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# Javascript runtime
RUN apt-get install -y nodejs

ADD dependencies /dependencies
WORKDIR dependencies

# PhantomJS for testing
RUN tar -xf phantomjs-*.tar.bz2 &&\
      mv phantomjs-*/bin/phantomjs /bin/ &&\
      rm -r phantom*

# Install dependencies for the `ruby-oci8` gem
RUN apt-get -y install libaio1 unzip
ENV LD_LIBRARY_PATH /dependencies/instantclient_11_2
RUN cd /dependencies/ &&\
      unzip instantclient-basic-linux.x64-11.2.0.3.0.zip &&\
      unzip instantclient-sdk-linux.x64-11.2.0.3.0.zip &&\
      cd instantclient_11_2 &&\
      ln -s libclntsh.so.11.1 libclntsh.so

# Create application working directory
ENV APP_DIR /app
RUN mkdir $APP_DIR
WORKDIR $APP_DIR

# Add Gemfile and install gems
ADD Gemfile* $APP_DIR/
ENV BUNDLE_PATH /box/bundle
RUN bundle install
