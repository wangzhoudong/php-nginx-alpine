#!/bin/bash
#设置FPM -参数
if   [   $SYS_MEM_SIZE   ] &&  [ ! -z "$SYS_MEM_SIZE" ];
then
	memTotal=${SYS_MEM_SIZE};
else
	memTotal=`awk '/MemTotal/{memtotal=$2}END{printf "%.0f",memtotal/1024/1024}' /proc/meminfo`;
fi

fpm_pm="dynamic";
fpm_max_children=`expr $memTotal*20|bc`;
fpm_start_servers=`expr $memTotal*2|bc`;
fpm_min_spare_servers=`expr $memTotal*2|bc`;
fpm_max_spare_servers=`expr $memTotal*20|bc`;
fpm_max_requests=`expr $memTotal*500|bc`;


#如果手动设置过参数使用手动设置的
if   [   $FPM_PM   ] &&  [ ! -z "$FPM_PM" ]; then
  fpm_pm=$FPM_PM
fi

if   [   $FPM_MAX_CHILDREN   ] &&  [ ! -z "$FPM_MAX_CHILDREN" ]; then
  fpm_max_children=$FPM_MAX_CHILDREN
fi

if   [   $FPM_START_SERVERS   ] &&  [ ! -z "$FPM_START_SERVERS" ]; then
  fpm_start_servers=$FPM_START_SERVERS
fi

if   [   $FPM_MIN_SPARE_SERVERS   ] &&  [ ! -z "$FPM_MIN_SPARE_SERVERS" ]; then
  fpm_min_spare_servers=$FPM_MIN_SPARE_SERVERS
fi

if   [   $FPM_MAX_SPARE_SERVERS   ] &&  [ ! -z "$FPM_MAX_SPARE_SERVERS" ]; then
  fpm_max_spare_servers=$FPM_MAX_SPARE_SERVERS
fi

if   [   $FPM_MAX_REQUESTS   ] &&  [ ! -z "$FPM_MAX_REQUESTS" ]; then
  fpm_max_requests=$FPM_MAX_REQUESTS
fi
echo $fpm_pm;
if [ ! -z "$fpm_pm" ]; then
 sed -i "s|pm =.*|pm = ${fpm_pm}|" /usr/local/etc/php-fpm.d/www.conf
fi

if [ ! -z "$fpm_max_children" ]; then
 sed -i "s|pm.max_children =.*|pm.max_children = ${fpm_max_children}|" /usr/local/etc/php-fpm.d/www.conf
fi

if [ ! -z "$fpm_start_servers" ]; then
 sed -i "s|pm.start_servers =.*|pm.start_servers = ${fpm_start_servers}|" /usr/local/etc/php-fpm.d/www.conf
fi

if [ ! -z "$fpm_min_spare_servers" ]; then
 sed -i "s|pm.min_spare_servers =.*|pm.min_spare_servers = ${fpm_min_spare_servers}|" /usr/local/etc/php-fpm.d/www.conf
fi

if [ ! -z "$fpm_max_spare_servers" ]; then
 sed -i "s|pm.max_spare_servers =.*|pm.max_spare_servers = ${fpm_max_spare_servers}|" /usr/local/etc/php-fpm.d/www.conf
fi

if [ ! -z "$fpm_start_servers" ]; then
 sed -i "s|pm.max_children =.*|pm.max_children = ${fpm_max_children}|" /usr/local/etc/php-fpm.d/www.conf
fi

if [ ! -z "$fpm_max_requests" ]; then
 sed -i "s|pm.max_requests =.*|pm.max_requests = ${fpm_max_requests}|" /usr/local/etc/php-fpm.d/www.conf
fi

#设置php.ini

if [ ! -z "$PHP_MEMORY_LIMIT" ]; then
 sed -i "s|memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|" /usr/local/etc/php/php.ini
fi

if [ ! -z "$MAX_UPLOAD" ]; then
  sed -i "s|upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|" /usr/local/etc/php/php.ini
fi

if [ ! -z "$PHP_MAX_FILE_UPLOAD" ]; then
  sed -i "s|max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|" /usr/local/etc/php/php.ini
fi

if [ ! -z "$PHP_MAX_POST" ]; then
    sed -i "s|post_max_size =.*|post_max_size = ${PHP_MAX_POST}|" /usr/local/etc/php/php.ini
fi

if [ ! -z "$PHP_OPCACHE_ENABLE" ]; then
    sed -i "s/;opcache.enable=1/opcache.enable=${PHP_OPCACHE_ENABLE}/" /usr/local/etc/php/php.ini
    sed -i "s/;opcache.enable_cli=0/opcache.enable_cli=${PHP_OPCACHE_ENABLE}/" /usr/local/etc/php/php.ini
fi

if [ ! -z "$PHP_OPCACHE_MEMORY" ]; then
   sed -i "s/;opcache.memory_consumption=.*/opcache.memory_consumption=${PHP_OPCACHE_MEMORY}/" /usr/local/etc/php/php.ini
fi
#重启FPM
supervisorctl restart php-fpm
