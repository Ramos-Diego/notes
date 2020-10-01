# Configure your firewall

We will setup a Firewall to control the inconming and outgoing network traffic. In the case of a web server this means opening port :80 for HTTP and :443 for HTTPS requests. Which means that anyone on the internet can request and see our page. In addition we have to open port :22 so that we can SSH into our server and manage it.

Be very carefull setting up your firewall. If you turn on / enable the firewall and port :22 is not open, you won't be able to access your server again.

Use the Uncomplicated Firewall (UFW) to verify the list of apps available on UWF

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

This will open port :22 for all network interfaces: 0.0.0.0
```sh
ufw allow OpenSSH
```
<mark>It's **IMPORTANT** that you don't forget to allow `OpenSSH` before enabling the firewall as you may get permanently locked out of your server.</mark>

Enable the firewall

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

Double check the open ports using the net-tools.

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
