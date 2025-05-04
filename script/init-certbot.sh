#!/bin/bash

DOMAIN="api.prisism.com"
EMAIL="me@bricn.net"

# 1. certbot 컨테이너로 인증서 요청
podman-compose run --rm certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email $EMAIL \
    --agree-tos \
    --no-eff-email \
    -d $DOMAIN

# 2. Nginx 다시 시작 (인증서 반영)
podman-compose restart nginx
