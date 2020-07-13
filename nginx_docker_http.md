```
server {
        listen 80;
        listen [::]:80;

        root /var/www/html;

        server_name decarriao.xyz www.decarriao.xyz;

        location / {
                proxy_pass http://nodejs:8080;
        }

        location ~ /.well-known/acme-challenge {
                allow all;
                root /var/www/html;
        }
}
```