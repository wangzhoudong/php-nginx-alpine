Docker PHP-FPM 7.1 & Nginx 1.12 on Alpine Linux
==============================================
    PHP-FPM 7.1 & Nginx 1.12 setup for Docker
-----
[![Build Status](https://travis-ci.org/wangzhoudong/php-nginx-alpine.svg?branch=master)](https://travis-ci.org/wangzhoudong/php-nginx-alpine)

#使用1:

    docker run --name test-php -p 80:80 -d dongen/php-nginx-alpine
    #阿里云同步仓库地址
    docker run --name test-php  -p 80:80 -d registry.cn-beijing.aliyuncs.com/dongen/php-nginx-alpine
##使用固定版本

     docker run --name test-php -p 80:80 -d dongen/php-nginx-alpine:73
     #阿里云同步仓库地址
     docker run --name test-php  -p 80:80 -d registry.cn-beijing.aliyuncs.com/dongen/php-nginx-alpine:73

#使用2 :

>  禁用opcache
```
docker run -e "PHP_OPCACHE_ENABLE=0" --name php -p 80:80 -d dongen/php-nginx-alpine
```
#-e 参数 详情 :
```
TIMEZONE   设置时区 如 -e "TIMEZONE=Asia/Shanghai"
PHP_MEMORY_LIMIT   设置运行内存 如 -e "PHP_MEMORY_LIMIT=512"
MAX_UPLOAD   设置php upload_max_filesize  -e "MAX_UPLOAD=50M"
PHP_MAX_FILE_UPLOAD   设置php max_file_uploads  -e "PHP_MAX_FILE_UPLOAD=200"
PHP_MAX_POST   设置php post_max_size  -e "PHP_MAX_FILE_UPLOAD=100M"
PHP_OPCACHE_ENABLE   设置opcache.enable  -e "PHP_OPCACHE_ENABLE=1"
PHP_OPCACHE_MEMORY   设置opcache.memory_consumption  -e "PHP_OPCACHE_MEMORY=256"

```


# 自定义php.ini
```
docker run--name php -p 80:80 -v /local/php.ini:/etc/php7/php.ini -d dongen/php-nginx-alpine
```
