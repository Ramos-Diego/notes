Install and configure NGINX as a reverse proxy serving static files and HTTPS enabled 

Install `apparmor` and `apparmor-utils`
```sh
apt update && apt install -y apparmor-profiles apparmor-utils
```

Create a blank profile

```sh
cd /etc/apparmor.d/
aa-autodep nginx
```

Put the new profile in complain mode

```sh
aa-complain nginx
```

Restart nginx
```sh
service nginx restart
```

Make one request to you domain by opening it in the browser:

`http://example.com:8080/index.html`

This will generate a list of this that NGINX asked to access in order to function

Allow everything that NGINX needs to work
```sh
aa-logprof
```

Verify that the changes were applied
```sh
nano /etc/apparmor.d/usr.sbin.nginx
```

Make sure to have at least the `#include` and `capability` lines included
```
# Last Modified: Tue Jul 21 23:19:57 2020
#include <tunables/global>

/usr/sbin/nginx flags=(complain) {
  #include <abstractions/apache2-common>
  #include <abstractions/base>
  #include <abstractions/nameservice>
  #include <abstractions/openssl>
  #include <abstractions/ssl_keys>

  capability dac_override,
  capability setgid,
  capability setuid,

  /var/www/html/** r,
  /path/to/example.com/public/** r,
  /var/log/nginx/access.log w,
  /var/log/nginx/error.log w,
  /usr/sbin/nginx mr,
  owner /etc/nginx/** r,
  owner /run/nginx.pid rw,
}
```
- Update the `/path/to/example.com/public/` line to include the entire directory and all of its subfolder with two asterisk (**)
- Make sure Nginx can write to the error log by setting w for `/var/log/nginx/error.log`

Save, enforce and reload the configuration
```sh
aa-enforce nginx && \
/etc/init.d/apparmor reload && \
service nginx restart
```

[SOURCE](https://www.digitalocean.com/community/tutorials/how-to-create-an-apparmor-profile-for-nginx-on-ubuntu-14-04)