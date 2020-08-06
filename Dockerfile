FROM php:7.4-fpm-alpine
LABEL Maintainer="Wangzd <wangzhoudong@foxmail.com>" \
      Description="Nginx 1.16 & PHP-FPM 7.4 based on Alpine Linux .  "

ENV TIMEZONE Asia/Shanghai

#安装基础服务
RUN apk --no-cache add tzdata git supervisor nginx curl vim \
          zlib zlib-dev m4 autoconf make gcc g++ linux-headers


RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
  echo "${TIMEZONE}" > /etc/timezone

RUN docker-php-ext-configure gd
RUN docker-php-ext-install -j$(nproc) gd opcache pdo_mysql gettext sockets


RUN pecl install redis \
    && pecl install swoole \
    && pecl install xlswriter \
    && docker-php-ext-enable redis swoole xlswriter

ENV COMPOSER_HOME /root/composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

RUN  apk del tzdata && \
      rm -rf /var/cache/apk/*
# Configure nginx
RUN rm -rf /etc/nginx/conf.d/default.conf
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/site-default.conf /etc/nginx/conf.d/default.conf


COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add application
RUN mkdir -p /run/nginx
RUN mkdir -p /var/www/html
WORKDIR /var/www/html
COPY src/ /var/www/html/

EXPOSE 80 443
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
