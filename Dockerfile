FROM ubuntu:12.04
MAINTAINER Ryan Seys <ryan@ryanseys.com>
RUN echo "deb http://archive.ubuntu.com/ubuntu precise universe" >> /etc/apt/sources.list
RUN apt-get update # DATE: 2013/10/26

RUN apt-get install -y default-jre ruby1.9.1-full git curl

# INSTALL NVM WITH LATEST NODE 0.10
RUN curl https://raw.github.com/creationix/nvm/master/install.sh | HOME=/root sh
RUN echo "[[ -s /root/.nvm/nvm.sh ]] && . /root/.nvm/nvm.sh" > /etc/profile.d/nvm.sh
RUN bash -l -c "nvm install 0.10"
RUN bash -l -c "nvm alias default 0.10"

RUN gem install bundler
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8
ADD . /src
RUN cd /src && bundle install; su -c "jekyll build"
CMD ["/bin/bash"]
