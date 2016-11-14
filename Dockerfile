FROM debian:latest

#copie du sources.list avec contrib non-free
COPY conf/sources.list /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    vim \
    nano \
    wget \
    sudo \
    cron \
    apache2 \
    libapache2-mod-php5 \
    openssh-server \
    mlocate \
    tree \
    php5 \
    php5-xsl \
    php5-xmlrpc \
    php5-gd \
    php5-pgsql \
    php-gettext \
    php-pear \
    php5-ldap \
    php5-imap \
    php5-mcrypt \
    php5-memcache \
    p7zip-full \
    LibreOffice \
    imagemagick \
    ghostscript \
    wkhtmltopdf \
    ttf-mscorefonts-installer \
    xvfb \
    poppler-utils \
    openjdk-7-jre \
    memcached \
    openssh-server \
    supervisor

RUN apt-get update && \
    apt-get install -y locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8 && \
    apt-get remove -y locales

ENV LANG C.UTF-8

#configuration pour supervisor qui permet l'execution de plusieurs services dans le coneteneur
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor

#copie des fichiers de conf
COPY conf/php-cli.ini /etc/php5/cli/php.ini
COPY conf/php-apache2.ini /etc/php5/apache2/php.ini
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#activation des modules spécifiques apache
RUN /usr/sbin/a2enmod headers
RUN /usr/sbin/a2enmod proxy
RUN /usr/sbin/a2enmod proxy_http

EXPOSE 22 80
CMD ["/usr/bin/supervisord"]

