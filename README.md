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
docker run -e "PHP_MEMORY_LIMIT=1024" --name php -p 80:80 -d 容器镜像
```
#-e 参数 详情 :
```
SYS_MEM_SIZE 设置系统分配的内存，会根据内存自动设置PHP参数 如果没设置会去取系统默认的 如 -e "SYS_MEM_SIZE=2" 表示2G内存
FPM_PM  设置fpm 运行模式 如 -e "FPM_PM=static"
FPM_MAX_CHILDREN 设置fpm 运行参数 如 -e "FPM_MAX_CHILDREN=2"
FPM_START_SERVERS 设置fpm 运行参数 如 -e "FPM_START_SERVERS=2"
FPM_MIN_SPARE_SERVERS 设置fpm 运行参数 如 -e "FPM_MIN_SPARE_SERVERS=2"
FPM_MAX_SPARE_SERVERS 设置fpm 运行参数 如 -e "FPM_MAX_SPARE_SERVERS=2"
FPM_MAX_REQUESTS 设置fpm 运行参数 如 -e "FPM_MAX_REQUESTS=2"

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
docker run--name php -p 80:80 -v /local/php.ini:/usr/local/etc/php/php.ini -d dongen/php-nginx-alpine
```
#运行实例
```
#安装 4G内存分配参数
docker run--name php -p 80:80  -e "SYS_MEM_SIZE=4" -d dongen/php-nginx-alpine
#手动设置参数FPM模式用静态分配内存
docker run--name php -p 80:80  -e "FPM_PM=static"  -e "FPM_MAX_CHILDREN=100"  -d dongen/php-nginx-alpine
#手动设置参数FPM模式用静态分配内存、设置PHP程序最大允许最大内存512G
docker run--name php -p 80:80  -e "FPM_PM=static"  -e "FPM_MAX_CHILDREN=100" -e "PHP_MEMORY_LIMIT=512"  -d dongen/php-nginx-alpine

```
