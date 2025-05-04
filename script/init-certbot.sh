#!/bin/bash

DOMAIN="api.prisism.com"
EMAIL="me@bricn.net"

# 인증서 발급을 위한 certbot 컨테이너 실행
podman run --rm \
    -v "prisism-letsencrypt:/etc/letsencrypt" \
    -v "prisism-certbot:/var/www/certbot" \
    certbot/certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email "$EMAIL" \
    --agree-tos \
    --no-eff-email \
    -d "$DOMAIN"

# 2. Nginx 다시 시작 (인증서 반영)
podman-compose restart nginx
