FROM ubuntu:14.04
MAINTAINER Dmytro Krasun <dmytro.krasun@tonicforhealth.com>

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en

RUN apt-get update

RUN apt-get -y --no-install-recommends install locales apt-utils &&\
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen &&\
    locale-gen en_US.UTF-8 &&\
    /usr/sbin/update-locale LANG=en_US.UTF-8

RUN apt-get install -y software-properties-common && add-apt-repository ppa:ondrej/php && apt-get update

# Ghostscript (for parsing and converting PDF to images)
RUN apt-get install -y ghostscript
# install unzip for extracting cached vendors
RUN apt-get install -y unzip

# MySQL password
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
# install curl, MySQL, Git
RUN apt-get install -y curl git mysql-server mysql-client

# install PHP and friends

RUN apt-get install -y curl php7.0 php7.0-curl php7.0-xdebug php7.0-mysql php7.0-xmlwriter php7.0-gd php7.0-apcu php7.0-apcu-bc php7.0-intl php7.0-bcmath php7.0-mbstring
RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin
RUN curl -o insight.phar -s http://get.insight.sensiolabs.com/insight.phar && mv 
RUN mv insight.phar /usr/local/bin/insight

# clean caches and clean package repository
RUN apt-get autoclean && apt-get clean && apt-get autoremove
