Enable firewall

```sh
ufw app list
```
You should see the following apps

```sh
Nginx Full
Nginx HTTP
Nginx HTTPS
OpenSSH
```

This will open port :80 (HTTP) and :443 (HTTPS)
```sh
ufw allow 'Nginx Full'
```

This will open port 22 for all network interfaces: 0.0.0.0
```sh
ufw allow OpenSSH
```
<mark>It's **IMPORTANT** that you don't forget to allow `OpenSSH` before enabling the firewall as you may get permanently locked out of your server.</mark>

Enable firewall
```sh
ufw enable
```

Check if the setup is correct
```sh
ufw status
```

Correct ouput
```
To                         Action      From
--                         ------      ----
OpenSSH                    ALLOW       Anywhere                  
Nginx Full                 ALLOW       Anywhere                  
OpenSSH (v6)               ALLOW       Anywhere (v6)             
Nginx Full (v6)            ALLOW       Anywhere (v6)
```

Double check with `ss`
```sh
netstat -tln
```

You should see the following
```
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     
tcp6       0      0 :::80                   :::*                    LISTEN     
tcp6       0      0 :::22                   :::*                    LISTEN     
```
---
