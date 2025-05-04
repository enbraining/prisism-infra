server {
    listen [::]:80;
    listen 80;

    server_name api.prisism.com;

    location ~ /.well-known/acme-challenge {
        allow all;
        root /var/www/certbot;
    }
}

server {
    listen 443 ssl;

    server_name api.prisism.com;

    ssl_certificate     /etc/letsencrypt/live/api.prisism.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.prisism.com/privkey.pem;

    location / {
        include /etc/nginx/proxy_params;
        proxy_pass http://183.105.197.228:3001;
    }

    location /socket.io/ {
        proxy_pass http://183.105.197.228:3030;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
    }
}