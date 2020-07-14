## Configure non-root user

Become root
```sh
sudo su
```

Add an user
```sh
adduser <insert-username>
```

Add user to the `docker` group to use docker without `sudo`
```sh
usermod -aG docker <insert-username>
```

Switch to the new user
```sh
sudo su -l <insert-username>
```
- `-, -l, --login`: make the shell a login shell

Verify you're using the right user
```sh
whoami
```

---
See if your nginx is working by going to the DNS you set up previously.

Find the nginx default root directory
```sh
cat /etc/nginx/nginx.conf | grep root
```

Get certificates
```sh
certbot certonly --webroot --register-unsafely-without-email --agree-tos -d <insert-domain.com> -w nginx/default/root/directory
```
`/usr/share/nginx/html` is the default nginx root directory for Amazon Linux 2. May vary in other linux distros.

Set up a cronjob to auto-renew SSL certificates
```sh
crontab -e
```

```sh
# Check if SSL certificate needs to be renewed everyday at 3AM
0 3 * * * certbot renew --post-hook "systemctl restart nginx"
```

Get DH Parameters for SSL
```sh
openssl dhparam -out /etc/ssl/certs/dhparam-2048.pem 2048
```

---

clone github project
```sh
git clone
```

Add, edit `myNginx.conf` and replace the placeholders
You must setup for HTTP first, then HTTPS
```sh
nano /etc/nginx/conf.d/myNginx.conf
```

Test you made no mistakes on `myNginx.conf`
```sh
nginx -t
```
```sh
# --------------------------------------------
# CORRECT OUTPUT:
# nginx: the configuration file /etc/nginx/nginx.conf syntax is ok  
# nginx: configuration file /etc/nginx/nginx.conf test is successful
# --------------------------------------------
```

Restart nginx
```sh
systemctl restart nginx
```

Check nginx status
```sh
systemctl status nginx | egrep 'Active|nginx.service -'
```

## TODO: Find better approach for this
Create a backup SSL certificates script at /root/SSL_BACKUP.sh
```sh
#!/bin/bash
# Compress and zip /letsencrypt directory and move it to a safe location

tar czf /etc/SSL_BACKUP.tar.gz /etc/letsencrypt/ 
```