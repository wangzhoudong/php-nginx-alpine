#!/bin/bash

if [ ! -z "$PHP_MEMORY_LIMIT" ]; then
 sed -i "s|memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|" /etc/php7/php.ini
fi

if [ ! -z "$MAX_UPLOAD" ]; then
  sed -i "s|upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|" /etc/php7/php.ini
fi

if [ ! -z "$PHP_MAX_FILE_UPLOAD" ]; then
  sed -i "s|max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|" /etc/php7/php.ini
fi

if [ ! -z "$PHP_MAX_POST" ]; then
    sed -i "s|post_max_size =.*|post_max_size = ${PHP_MAX_POST}|" /etc/php7/php.ini
fi

if [ ! -z "$PHP_OPCACHE_ENABLE" ]; then
    sed -i "s/;opcache.enable=1/opcache.enable=${PHP_OPCACHE_ENABLE}/" /etc/php7/php.ini
    sed -i "s/;opcache.enable_cli=0/opcache.enable_cli=${PHP_OPCACHE_ENABLE}/" /etc/php7/php.ini
fi

if [ ! -z "$PHP_OPCACHE_MEMORY" ]; then
   sed -i "s/;opcache.memory_consumption=.*/opcache.memory_consumption=${PHP_OPCACHE_MEMORY}/" /etc/php7/php.ini
fi
