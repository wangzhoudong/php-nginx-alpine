FROM alpine:3.12.0
LABEL Maintainer="Wangzd <wangzhoudong@foxmail.com>" \
      Description="Nginx 1.16 & PHP-FPM 7.3 based on Alpine Linux .  "

ENV TIMEZONE Asia/Shanghai
ENV PHP_MEMORY_LIMIT 256M
ENV MAX_UPLOAD 50M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST 100M
ENV PHP_OPCACHE_ENABLE 1
ENV PHP_OPCACHE_MEMORY 256
ENV PHP_MAX_CHILDRENY 120
ENV PPM_MAX_CHILDREN 256
ENV PPM_START_SERVERS 10
ENV PPM_MIN_SPARE_SERVERS 10
ENV FPM_MAX_SPARE_SERVERS 30


#安装基础服务
RUN echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk --no-cache add git supervisor nginx curl tzdata ;


#安装PHP


RUN cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
  echo "${TIMEZONE}" > /etc/timezone && \
  apk  --no-cache add \
    php7 \
    php7-common \
    php7-redis \
    php7-intl \
    php7-gd \
    php7-imagick \
    php7-tokenizer \
    php7-fileinfo \
    php7-mcrypt \
    php7-openssl \
    php7-gmp \
    php7-json \
    php7-dom \
    php7-pdo \
    php7-zip \
    php7-zlib \
    php7-mysqli \
    php7-bcmath \
    php7-pdo_mysql \
    php7-gettext \
    php7-xmlreader \
    php7-xmlrpc \
    php7-xmlwriter \
    php7-bz2 \
    php7-iconv \
    php7-curl \
    php7-ctype \
    php7-fpm \
    php7-mbstring \
    php7-simplexml \
    php7-opcache \
    php7-session \
    php7-pcntl \
    php7-posix \
    php7-pecl-xlswriter \
    php7-phar && \
    curl -sS https://getcomposer.org/installer | \
    php7 -- --install-dir=/usr/bin --filename=composer && \
  apk del tzdata && \
  rm -rf /var/cache/apk/*

COPY lib/phpunit.phar /usr/local/bin/phpunit
RUN chmod +x /usr/local/bin/phpunit
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
# Configure nginx
RUN rm -rf /etc/nginx/conf.d/default.conf
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/site-default.conf /etc/nginx/conf.d/default.conf

# Configure PHP-FPM
RUN rm -rf /etc/php7/php-fpm.d/www.conf
COPY config/php-fpm.d/www.conf /etc/php7/php-fpm.d/www.conf
COPY config/php.ini /etc/php7/conf.d/zzz_custom.ini
RUN sed -i "s|;date.timezone =.*|date.timezone = ${TIMEZONE}|" /etc/php7/php.ini && \
    sed -i "s|memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|" /etc/php7/php.ini && \
    sed -i "s|upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|" /etc/php7/php.ini && \
    sed -i "s|max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|" /etc/php7/php.ini && \
    sed -i "s|post_max_size =.*|post_max_size = ${PHP_MAX_POST}|" /etc/php7/php.ini && \
    sed -i "s|expose_php =.*|expose_php = Off|" /etc/php7/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php7/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php7/php.ini && \
    sed -i "s/;opcache.enable=1/opcache.enable=${PHP_OPCACHE_ENABLE}/" /etc/php7/php.ini && \
    sed -i "s/;opcache.enable_cli=0/opcache.enable_cli=${PHP_OPCACHE_ENABLE}/" /etc/php7/php.ini && \
    sed -i "s/;opcache.memory_consumption=.*/opcache.memory_consumption=${PHP_OPCACHE_MEMORY}/" /etc/php7/php.ini && \
    sed -i "s/;opcache.file_cache=.*/opcache.file_cache=\/tmp/" /etc/php7/php.ini
# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add application
RUN mkdir -p /var/www/html
WORKDIR /var/www/html
COPY src/ /var/www/html/

EXPOSE 80 443

ADD srripts/init.sh /init.sh
RUN chmod 755 /init.sh

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
