FROM php:7.2-apache

LABEL maintainer="you"

ENV ACCEPT_EULA=Y

#needed for sql driver install to work.
RUN apt-get update && apt-get install -my wget gnupg 

# apache mod rewrite
RUN docker-php-ext-install pdo_mysql \
   && docker-php-ext-install opcache \
   && a2enmod rewrite negotiation

# Microsoft SQL Server Prerequisites
RUN apt-get update \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/9/prod.list \
        > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get install -y --no-install-recommends \
        locales \
        apt-transport-https \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        msodbcsql17 \
        unixodbc-dev

RUN docker-php-ext-install mbstring pdo pdo_mysql \
    && pecl install sqlsrv pdo_sqlsrv  \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv 

#placing copies at the bottom in prep for having an image with all the above that we layer the files on to separately.
COPY .docker/php/php.ini /usr/local/etc/php
COPY .docker/apache/vhost.conf /etc/apache2/sites-available/000-default.conf

#Note: be careful here, the docker ignore specifies to skip the .env, and envbackup.env, are there other files that should be skipped?
COPY . /srv/app


#From https://serverfault.com/questions/772227/chmod-not-working-correctly-in-docker
RUN /bin/bash -c 'ls -la /srv/app/storage; chmod 777 -R /srv/app/storage; ls -la /srv/app/storage'
RUN /bin/bash -c 'ls -la /srv/app/bootstrap/cache; chmod 777 -R /srv/app/bootstrap/cache; ls -la /srv/app/bootstrap/cache'