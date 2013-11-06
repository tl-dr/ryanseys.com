FROM ubuntu:12.04
MAINTAINER Ryan Seys <ryan@ryanseys.com>
RUN echo "deb http://archive.ubuntu.com/ubuntu precise universe" >> /etc/apt/sources.list
RUN apt-get update # DATE: 2013/10/26
RUN apt-get upgrade -y
RUN apt-get install -y build-essential python-software-properties python g++ make software-properties-common default-jre ruby1.9.1-full
RUN add-apt-repository ppa:chris-lea/node.js && apt-get update
RUN apt-get install -y nodejs
RUN gem install bundler
ADD . /src
RUN cd /src; bundle install
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN cd /src; su jekyll build
