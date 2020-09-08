## 4. Get SSL certificates

Confirm that nginx is working by going to the domain you set up previously. **example.com**

If not, check that:
  1. Nginx is running: `systemctl status nginx`
  2. Port `:80` is open in your droplet: `netstat -tln`

Find the nginx default root directory
```sh
cat /etc/nginx/sites-available/default | grep root
```
`/var/www/html` is the default nginx root directory for Ubuntu 18. May vary in other linux distros.

Get SSL certificates
```sh
certbot certonly --webroot --email your@email.com --no-eff-email --agree-tos -w /var/www/html -d example.com -d www.example.com
```

Get DH Parameters
```sh
openssl dhparam -out /etc/nginx/dhparam.pem 2048
```

The nginx configuration is a bit lengthy. Grab the files from GitHub.

Edit `nginx.conf`
```sh
nano /etc/nginx/nginx.conf
```

Add, edit `example.com.conf`, `proxy.conf`, `security.conf` and replace the placeholders
```sh
nano /etc/nginx/conf.d/example.com.conf
nano /etc/nginx/snippets/proxy.conf
nano /etc/nginx/snippets/security.conf
```

All the lines that must be edited have `# EDIT HERE` at the end.
```sh
server_name example.com; # EDIT HERE
```

Test you made no mistakes configuring NGINX
```sh
nginx -t
```

Correct output
```sh
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok  
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

Restart nginx
```sh
systemctl restart nginx && \
systemctl status nginx
```

Set up a cronjob to auto-renew SSL certificates
```sh
crontab -e
```

```sh
# ┌ minute (0 - 59)
# │ ┌ hour (0 - 23)
# │ │ ┌ day of month (1 - 31)
# │ │ │ ┌ month (1 - 12)
# │ │ │ │ ┌ day of week (0 - 6) (Sunday to Saturday;
# │ │ │ │ │                      7 is also Sunday on some systems)
# │ │ │ │ │
# * * * * *  command_to_execute

# USEFUL WEBSITE TO CREATE CRONJOBS
# https://crontab.guru/

# Check if SSL certificate needs to be renewed everyday at 3AM
0 3 * * * certbot renew --post-hook "systemctl restart nginx"
```

Verify that cronjob is running by reading the cron logs
```
tail /var/log/cron
```

---

## TODO: Find better approach for this
Create a backup SSL certificates script at /root/SSL_BACKUP.sh
```sh
#!/bin/bash
# Compress and zip /letsencrypt directory and move it to a safe location

tar czf /etc/SSL_BACKUP.tar.gz /etc/letsencrypt/ 
```