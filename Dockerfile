FROM ubuntu:12.04
MAINTAINER Ryan Seys <ryan@ryanseys.com>
RUN echo "deb http://archive.ubuntu.com/ubuntu precise universe" >> /etc/apt/sources.list
RUN apt-get update # DATE: 2013/10/26
RUN apt-get upgrade -y
RUN add-apt-repository ppa:chris-lea/node.js && apt-get update
RUN apt-get install -y build-essential python-software-properties python g++ make software-properties-common default-jre ruby1.9.1-full nodejs
RUN gem install bundler
ADD . /src
RUN cd /src; bundle install
CMD ["jekyll", "build"]
