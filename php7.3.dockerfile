FROM php:7.4-fpm

# Set working directory
WORKDIR /var/www/html

ENV ACCEPT_EULA=Y

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# COPY baadbaan_new .

RUN apt-get update && apt-get install -y \
    locales \
    zip \
    unzip \
    curl \
    libzip-dev\
    libbz2-dev\
    libxml2-dev\
    zlib1g-dev\
    libmcrypt-dev \
    libpng-dev\
    libonig-dev\
    libffi-dev\
    libtidy-dev\
    libldap2-dev\
    libgmp-dev\
    libjpeg-dev\
    libfreetype6-dev\
    git\
    ssh 

# Install extensions
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install zip  
RUN docker-php-ext-install bz2  
RUN docker-php-ext-install gmp  
RUN docker-php-ext-install ffi  
RUN docker-php-ext-install gettext
RUN docker-php-ext-install exif
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install iconv
RUN docker-php-ext-install xml
RUN docker-php-ext-install simplexml
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd 
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install sockets
RUN docker-php-ext-install soap
RUN docker-php-ext-install tidy
RUN docker-php-ext-install ldap

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y --no-install-recommends install apt-utils libxml2-dev gnupg apt-transport-https \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*


# Install MS ODBC Driver for SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && apt-get -y --no-install-recommends install msodbcsql17 unixodbc-dev \
    && pecl install --force sqlsrv \
    && pecl install --force pdo_sqlsrv \
    && echo "extension=pdo_sqlsrv.so" >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_sqlsrv.ini \
    && echo "extension=sqlsrv.so" >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-sqlsrv.ini \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN chown -R www-data:www-data /var/www/html
