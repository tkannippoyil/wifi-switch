# Download Base Container Python from hub.docker.com
FROM ruby:2.2.2

# Create base directory
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs mosquitto
RUN mkdir /backend
WORKDIR /backend

ENV RAILS_ENV=development

# Install depended Files
ADD Gemfile /backend/Gemfile
ADD Gemfile.lock /backend/Gemfile.lock
RUN gem install bundler
RUN bundle install
COPY . /backend

