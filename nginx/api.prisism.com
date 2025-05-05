server {
    listen [::]:80;
    listen 80;

    server_name api.prisism.com;

    location /.well-known/acme-challenge/ {
        allow all;
        root /var/www/certbot;
    }

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    server_name api.prisism.com;

    ssl_certificate     /etc/letsencrypt/live/api.prisism.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.prisism.com/privkey.pem;

    location / {
        include /etc/nginx/proxy_params;
        proxy_pass http://host.containers.internal:3001;
    }

    location /socket.io/ {
        proxy_pass http://host.containers.internal:3030;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
    }
}
