Docker PHP-FPM 7.1 & Nginx 1.12 on Alpine Linux
==============================================
Example PHP-FPM 7.1 & Nginx 1.12 setup for Docker, build on [Alpine Linux](http://www.alpinelinux.org/).
The image is only +/- 35MB large.
[![Build Status](https://travis-ci.org/wangzhoudong/php-nginx-alpine.svg?branch=master)](https://travis-ci.org/wangzhoudong/php-nginx-alpine)
使用
-----
Start the Docker containers:

    docker run -p 80:80 dongen/nginx-php-alpine

访问 http://localhost
