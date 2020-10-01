# Get SSL certificates

SSL certificates enable HTTPS in your website.

You not have realized, but if you followed the previous instructions correctly, you're already running an Nginx server.

Confirm that nginx is working by going to the domain you set up previously. **example.com** in your browser.

If cannot reach your website in the browser, check that:
  1. Nginx is running: `systemctl status nginx`
  2. Port `:80` is open in your droplet: `netstat -tln`

## Setup Nginx as a reverse proxy server

First we need to find the nginx default root directory
```sh
cat /etc/nginx/sites-available/default | grep root
```
`/var/www/html` is the default nginx root directory for Ubuntu 18. May vary in other linux distros.

We need to provide this directory to certbot. It will create a file in this directory and request from another server. This confirms that your are indeed the owner of this server.

Insert your email and domain in this command to get the SSL certificates
```sh
certbot certonly --webroot --email your@email.com --no-eff-email --agree-tos -w /var/www/html -d example.com -d www.example.com
```

Get DH Parameters. Diffie–Hellman key exchange is a method of securely exchanging cryptographic keys over a public channel. This adds another layer of security to your server.
```sh
openssl dhparam -out /etc/nginx/dhparam.pem 2048
```

NGINX has an inmense amount of options. You can configure many ways. I've saved the configurations that I used in Github.

Here is a high-level view of my configuration

THIS IS A REVERSE PROXY SETUP FOR NGINX USING NODEJS (HTTPS ENABLED)
```
                         +---------------------------------+
                         |              SERVER             |
                         | +------------- +--------------+ |
                         | |      HTTP    | static files | |
                         | |  +---------> +--------------+ |
                         | v  |                            |
                    +----+-+--+-+         +--------------+ |
 +--------+ +-----> |   nginx   | +-----> |    nodejs    | |
 | client |  HTTPS  |0.0.0.0:80 |   HTTP  |              | |
 +--------+ <-----+ |0.0.0.0:443| <-----+ |localhost:8080| |
                    +----+------+         +--------------+ |
                         +---------------------------------+
```
The `ngixn.conf` contains all the configurations for NGINX, however we will not directly type all the configuration in this single file. Instead we will split up the configuration and import all the pieces `ngixn.conf`. This is extremely useful because every domain/website configuration is stored separately.

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

crontab is used in Linux to schedule command executions. Set up a cronjob to auto-renew SSL certificates

Open the current crontab configuration

```sh
crontab -e
```

Paste the following command to auto-renew your SSL certificates
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
