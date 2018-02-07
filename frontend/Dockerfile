FROM node:8.6.0
RUN mkdir /frontend
COPY . /frontend

# The base node image sets a very verbose log level.
ENV NPM_CONFIG_LOGLEVEL warn

RUN cd /frontend && npm install
WORKDIR /frontend
