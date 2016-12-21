# https://hub.docker.com/r/krasun/bitbucket-pipelines-survey-designer-server/
FROM ubuntu:16.04
MAINTAINER Dmytro Krasun <dmytro.krasun@tonicforhealth.com>

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en

RUN apt-get update

RUN apt-get -y --no-install-recommends install locales apt-utils &&\
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen &&\
    locale-gen en_US.UTF-8 &&\
    /usr/sbin/update-locale LANG=en_US.UTF-8

# Ghostscript (for parsing and converting PDF to images)
RUN apt-get install -y ghostscript
# install unzip for extracting cached vendors
RUN apt-get install -y unzip

# MySQL password
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections

# install PHP and friends
RUN apt-get install -y curl git mysql-server mysql-client
RUN apt-get install -y curl php php-xdebug php-mysql
RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin

# clean caches and clean package repository
RUN apt-get autoclean && apt-get clean && apt-get autoremove