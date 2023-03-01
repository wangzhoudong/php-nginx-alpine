FROM php:8.1-fpm-alpine
LABEL Maintainer="Wangzd <wangzhoudong@foxmail.com>" \
      Description="Nginx 1.16 & PHP-FPM 7.4 based on Alpine Linux .  "

ENV TIMEZONE Asia/Shanghai
ENV PHP_MEMORY_LIMIT 256M
ENV MAX_UPLOAD 50M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST 100M
#ENV SYS_MEM_SIZE 3
#使用阿里云的源防止超时
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

#安装基础服务
RUN apk update && apk add tzdata git supervisor nginx curl vim \
           m4 autoconf make gcc g++ linux-headers \
               imagemagick-dev libmcrypt-dev zlib-dev libpng-dev libzip-dev libwebp-dev jpeg-dev libjpeg-turbo-dev freetype-dev \
               libintl icu icu-dev oniguruma oniguruma-dev openssl openssl-dev


RUN cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
  echo "${TIMEZONE}" > /etc/timezone

# Configure PHP-FPM
RUN rm -rf /usr/local/etc/php-fpm.d/www.conf
COPY config/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
RUN sed -i "s|;date.timezone =.*|date.timezone = ${TIMEZONE}|" /usr/local/etc/php/php.ini && \
    sed -i "s|memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|" /usr/local/etc/php/php.ini && \
    sed -i "s|upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|" /usr/local/etc/php/php.ini && \
    sed -i "s|max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|" /usr/local/etc/php/php.ini && \
    sed -i "s|post_max_size =.*|post_max_size = ${PHP_MAX_POST}|" /usr/local/etc/php/php.ini && \
    sed -i "s|expose_php =.*|expose_php = Off|" /usr/local/etc/php/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /usr/local/etc/php/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /usr/local/etc/php/php.ini


RUN docker-php-ext-configure gd --with-webp=/usr/include  --with-jpeg=/usr/include --with-freetype=/usr/include
RUN docker-php-ext-install  gd pdo_mysql opcache bcmath pcntl zip intl
#RUN docker-php-ext-install  gd opcache pdo_mysql gettext sockets


RUN pecl install redis \
    && pecl install mongodb \
    && pecl install swoole \
    && pecl install xlswriter \
    && pecl install mcrypt \
    && pecl install imagick \
    && docker-php-ext-enable redis mongodb swoole xlswriter mcrypt imagick


ENV COMPOSER_HOME /root/.composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

RUN  apk del tzdata && \
      rm -rf /var/cache/apk/*

#兼容之前单独安装的环境
RUN ln -s /usr/local/bin/php /usr/bin/php7
RUN ln -s /usr/local/sbin/php-fpm /usr/sbin/php-fpm7


# Configure nginx
RUN rm -rf /etc/nginx/conf.d/default.conf
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/site-default.conf /etc/nginx/conf.d/default.conf


COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/supervisord.conf /etc/supervisord.conf

COPY config/00-alpine.conf  /etc/sysctl.d/00-alpine.conf
RUN cat /etc/sysctl.d/00-alpine.conf >> /etc/sysctl.conf

# Add application
RUN mkdir -p /run/nginx
RUN mkdir -p /var/www/html
WORKDIR /var/www/html
COPY src/ /var/www/html/

ADD scripts/init.sh /init.sh
RUN chmod 755 /init.sh

# Add user group and user devops
RUN cat /etc/passwd
RUN addgroup -g 1000 devops
RUN adduser -D -u 1000 -G devops devops
RUN chown -R devops:devops /var/www
RUN chown -R devops:devops /run

## alpine 网络问题
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r0/glibc-2.35-r0.apk
RUN apk add glibc-2.35-r0.apk
RUN rm -f glibc-2.35-r0.apk
EXPOSE 80 443
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
