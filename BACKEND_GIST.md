# Securely deploy and mantain Node.js apps

Even though AWS has tools such as Elastic Beanstalk, which automates and enables our apps to be managed using a GUI, by performing a manual setup you gain a better understanding of Elastic Beastalk and the ability to deploy an app from any other service provider. You could even follow these steps to run an app in a Raspberry Pi. The sky is the limit.

## Topics

- Amazon Web Services (AWS)
- PM2
- Nginx
- Reverse proxy
- SSL certificates and HTTPS
- Cronjobs (Scheduled tasks)
- SELinux

### Launch EC2 instance

Remember that you can only run one EC2 instance at a time to stay within AWS' free tier.

Once our app is ready for deployment follow these steps:

- Create an EC2 instance and download the key pair to ssh into it.
- Associate an Elastic IP to the instance

Open PORT 22 and add your IP to be able to SSH into the EC2 instance.

```
Right click on instance > Networking > Change security groups > [Simply note the instance's security group]

EC2 Dashboard > Network and Security > Security Groups > [Select the instance's security group] > Inbound rules > Edit inbound rules > Add Rule > Fill the fields according to this table
```

You can also open PORT 80 (HTTP) and 443 (HTTPS) because this will be the setup for the entire project. The result should look like this.

EC2 > Security Groups 

| Type  | Protocol | Port range | Source (CIDR blocks) | Description   |
|-------|----------|------------|----------------------|---------------|
| HTTP  | TCP      | 80         | 0.0.0.0/0            | HTTP          |
| SSH   | TCP      | 22         | 1.2.3.4/24           | ADMIN IP ONLY |
| HTTPS | TCP      | 443        | 0.0.0.0/0            | HTTPS         |

Learn about [CIDR blocks](https://www.youtube.com/watch?v=z07HTSzzp3o).

---

Save the `.pem` file that you downloaded when creating the EC2 instance in a safe location in your local machine. 

### Change the SSH key's permissions

```sh
chmod 400 /path/to/key.pem
```

### Setup your local computer to connect through SSH

I recommend you setup an alias in your local machine to remote into your server. Note that the default ssh usernames for EC2 instances changes depending on the distro.

Amazon Linux
```sh
echo "alias ec2='sudo ssh -i /path/to/<key-name>.pem ec2-user@<insert-public-ip>'" >> ~/.bash_aliases
```

Ubuntu
```sh
echo "alias ec2='sudo ssh -i /path/to/<key-name>.pem ubuntu@<insert-public-ip>'" >> ~/.bash_aliases
```

Confirm the alias is setup 
```sh
alias | grep 'ec2'
```

Connect to your EC2 instance
```sh
ec2
```

File permissions cheat sheet

```
---------------- FILE RIGHTS ----------------

                USER
-:FILE           + GROUP       r:READABLE
d:DIRECTORY      |   +  ALL    w:WRITEABLE
l:LINK          +++ +++ +++    x:EXECUTABLE
FILE TYPE --> - rwx r-x -wx    -:DENIED
                +++ +++ +++    EXAMPLES:
                421 421 421             drw-rwxrwx
                 v   v   v              -r--r--r--
    CHMOD 753 =  7   5   3              lrwx---rwx
```

### Note

I will provide examples in Amazon Linux 2 and Ubuntu because these derive from Debian and REHL, which are the type of Linux distributions you're most likely to use on your server.

Although this tutorial is done with AWS EC2 running Amazon Linux 2 (AL2), you can follow along the general setup in any linux distro. 

If your server is runnin Ubuntu, you will use `apt-get` instead of `yum` as a package manager and `AppArmor` instead of `SELinux` to secure the server.

Use this command to know what kind of Linux distro you're using:

```sh
cat /etc/*release | grep 'ID_LIKE'
# OUPUT for Amazon Linux 2
# ID_LIKE="centos rhel fedora"
```

### Become `root` to setup the server

```sh
sudo su
```

If you're not `root` you will need to preceed all commands with `sudo`.

---

### Update and upgrade your linux OS

Amazon Linux
```sh
yum -y update
```
- `-y`: Don't ask for confirmation

Ubuntu
```sh
sudo apt-get update && sudo apt-get upgrade -y
```

TODO: What does the dev tools contian?

### Install Development Tools

Amazon Linux
```sh
yum -y groupinstall "Development Tools"
```

Ubuntu

```sh
sudo apt-get install net-tools
```
```sh
sudo apt-get install build-essential
```

Verify that you have Vim and net-tools installed

```sh
yum list installed | egrep 'vim|net-tools'
```

### Install Node.js in Amazon Linux 2

Download the necessary [packages](https://packages.ubuntu.com/) to install Node.js

Install Node.js:

Amazon Linux
```sh
curl -sL https://rpm.nodesource.com/setup_14.x | bash -
```

Ubuntu
```sh
curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt-get install -y nodejs
```


Yarn is a faster and improved alternative to NPM.

- Install [yarn](https://classic.yarnpkg.com/en/docs/install/#centos-stable)

Amazon Linux
```sh
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
```
```sh
yum install yarn
```

Ubuntu
```sh
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
```
```sh
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
```
```sh
sudo apt update && sudo apt install yarn
```

### Install PM2

yarn
```
yarn add -g pm2
```
NPM
```sh
npm install -g pm2
```

Once the server has been setup, we need to create a non-root user. You should not run any app that can access the internet as root.

---

### Configure non-root user

Add an user

```sh
adduser <insert-username>
```

Make user an admin by adding to 'wheel' group (Optional)
```sh
usermod -aG wheel <insert-username>
```

See what groups the user is added to

```sh
groups
```

Switch to someUser

```sh
sudo su - someUser
```

Verify your user

```sh
whoami
```

Set up keys to connect without password

```sh
mkdir ~/.ssh
```

Change folder permissions

700: gives **r**ead, **w**rite and e**x**excute permission to the owner

`700 = - rwx --- ---`

```sh
chmod 700 ~/.ssh
```

Create new keys file

```sh
touch ~/.ssh/authorized_keys
```

Change keys permissions

600: gives **r**ead, **w**rite and permission to the owner

`600 = - rw- --- ---`
```sh
chmod 600 ~/.ssh/authorized_keys
```

Verify permissions

```sh
ls -lRa ~/. | egrep '.ssh|authorized_keys'
```

- `-l`: Verbose output
- `-R`: Recursive mode
- `-a`: All files 

### All in one command

```sh
adduser <insert-username> && \
mkdir ~/.ssh && \
chmod 700 ~/.ssh && \
touch ~/.ssh/authorized_keys && \
chmod 600 ~/.ssh/authorized_keys && \
ls -lRa ~/. | egrep '.ssh|authorized_keys'
```

---

For the sake of this tutorial we will zip our app and send it to the server using SSH. In a more advance setup this could be automated such that upon a commit to github the app gets updated in the server. Learn more about CI/CD.  

### Compress your app
# TODO: see if you can exclude files instead of adding all
```sh
tar czf <FILENAME>.tar.gz file1 file2 file3
```

Tranfer files from the local machine to the server

```sh
sudo scp -i keys.pem <FILENAME>.tar.gz <USER>@<EC2 PUBLIC IP>:~
```

Connect to your server and extract your app

```sh
tar xf <FILENAME>.tar.gz
```

Now we are going to run our app using PM2. This tool manages our app and automatically restarts the app upon reboot.

### Run app with PM2

```sh
pm2 start --name <insert-process-name> app.js
```

Persist app upon reboot with PM2

```sh
pm2 startup
```

**FOLLOW THE INSTRUCTIONS PROVIDED BY PM2**

Restart EC2 instance (DANGER)

```sh
reboot
```

or

```bash
shutdown -r now
```

Create a deploy script

```sh
touch deploy.sh
```

```sh
#!/bin/bash

# Compress all the necessary files
tar czf <filename>.tar.gz serve.js  package.json public README.md
# c : compress, z : zip, f : file

# Transfer files to EC2 instance
sudo scp -i <key-name>.pem <filename>.tar.gz ec2-user@<EC2-public-ip>:~
# -i : Insert private key file

# Remove the .tar.gz file from local PC
rm <filename>.tar.gz

# Run commands remotely
ssh ec2-user@<EC2-public-ip> << 'ENDSSH'
# Stop PM2 app
pm2 stop <app name>

# Delete current version of the app
rm -rf <app directory>

# Create new app directory
mkdir <new app directory>

# Unzip .tar.gz file
tar xf <ANYFILE>.tar.gz -C <new app directory>
# x : extract, f : file

# Install dependencies
cd <new app directory>
yarn install

# restart app
pm2 start <new app name>
ENDSSH
```

- SELinux configuration [article](https://www.digitalocean.com/community/tutorials/an-introduction-to-selinux-on-centos-7-part-1-basic-concepts), [video](https://www.youtube.com/watch?v=HhydNtaLEK0&list=PLQlWzK5tU-gDyxC1JTpyC2avvJlt3hrIh&index=9)

---
## SELinux

Allow HTTP servers to connect to other backends

```sh
setsebool -P httpd_can_network_connect on
```
- `-P`: persist change

Allow HTTP servers to read files from user home directory

```sh
setsebool -P httpd_enable_homedirs on
```

Change the context of the static folder and its files to be accessible

```sh
chcon -Rt httpd_sys_content_t /path/to/static_folder
```
- `-R`: Recursive change
- `-t`: Change directory/file TYPE

Check SELinux mode

```sh
getenforce
```
SELinux debugging

Set SELinux to enforce mode

```sh
setenforce 1
```

Set SELinux to permissive mode

```sh
setenforce 0
```

Check the context details for files and directories
```sh
ls -lZ
```

Check context of current processes
```sh
ps auxZ
```

---
### Network intefaces


Interface configuration
```sh
ifconfig 
```

Network statistics
```sh
netstat
```

View open ports using netstat

```sh
netstat -tln 
```

- `-t`: Only TCP
- `-l`: Ports that are listening
- `-n`: IPs as numbers, not hostnames

Expected output:

```
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 127.0.0.1:8080          0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:443             0.0.0.0:*               LISTEN
tcp6       0      0 :::80                   :::*                    LISTEN
tcp6       0      0 :::22                   :::*                    LISTEN
tcp6       0      0 :::443                  :::*                    LISTEN
```

---

## Nginx

Extra Packages for Enterprise Linux

```sh
yum install -y epel-release 
```

epel-release is available in Amazon Linux Extra topic "epel"   

```sh
amazon-linux-extras install epel
```

Install Nginx

```sh
yum install -y nginx 
```

### Start Nginx

With `systemctl` you can control the system manager on REHL and Debian like systems. 

Start the nginx process
```sh
systemctl start nginx
```

Check status
```bash
systemctl status nginx
```

Make Nginx persistant on restart
```bash
systemctl enable nginx
```

Edit Nginx config file
```bash
vim /etc/nginx/nginx.conf
```

# NGINX CONFIGURATION

Feel free to delete comments if you decide to use this configuration and your understand what is happening. 
```
# THIS FILE: /etc/nginx/conf.d/yourNginx.conf

# THIS IS A REVERSE PROXY SETUP FOR NGINX USING NODEJS (HTTPS ENABLED)

#                         +---------------------------------+
#                         |              SERVER             |
#                         | +------------- +--------------+ |
#                         | |      HTTP    | static files | |
#                         | |  +---------> +--------------+ |
#                         | v  |                            |
#                    +----+-+--+-+         +--------------+ |
# +--------+ +-----> |   nginx   | +-----> |    nodejs    | |
# | client |  HTTPS  |0.0.0.0:80 |   HTTP  |              | |
# +--------+ <-----+ |0.0.0.0:443| <-----+ |localhost:8080| |
#                    +----+------+         +--------------+ |
#                         +---------------------------------+

# The upstream is commonly called 'backend' instead of 'nodejs' 
# Defines a group of servers. Servers can listen on different ports.
# https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream
upstream nodejs {
  server localhost:8080;
}

# generated 2020-06-20, Mozilla Guideline v5.4, nginx 1.17.7, OpenSSL 1.1.1d, intermediate configuration
# https://ssl-config.mozilla.org/#server=nginx&version=1.17.7&config=intermediate&openssl=1.1.1d&guideline=5.4

# --------- MOZILLA'S SUGGESTED SETUP ----------

# Listen to any HTTP (:80) request and redirect to HTTPS (:443). 
server {
  listen 80; # IPv4
  listen [::]:80; # IPv6
  server_name www.example.com example.com;
  return 301 https://$host$request_uri;
}

# Handle all HTTPS requests 
server {
  listen 443 ssl http2; # IPv4
  listen [::]:443 ssl http2; # IPv6

  # -------- GET SSL CERTIFICATES (RUN AS ROOT) ----------

  # Generate SSL certificates using certbot
  # $ certbot certonly --webroot -d <insert-domain.com> -w /path/to/static-files/directory
  # This will generate the ssl_certificate and ssl_certificate_key
  # without making any changes to our .conf file

  # Fill in the <insert-domain.com> as seen below
  # $ vim /etc/nginx/conf.d/yourNginx.conf

  ssl_certificate /etc/letsencrypt/live/<insert-domain.com>/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/<insert-domain.com>/privkey.pem;

  # After saving the changes, MAKE SURE YOU MADE NO MISTAKES
  # $ nginx -t
  # CORRECT OUTPUT:
  # nginx: the configuration file /etc/nginx/nginx.conf syntax is ok  
  # nginx: configuration file /etc/nginx/nginx.conf test is successful

  # If and only if everything is okay, restart nginx
  # $ systemctl restart nginx

  # Optional: Check the nginx status after restart.
  # $ systemctl status nginx
  # You should see "Active: active (running)"

  # Create a backup SSL certificates script at /root/SSL_BACKUP.sh (SAFETY FIRST)

  # #!/bin/bash
  # Compress and zip /letsencrypt directory and move it to a safe location
  # $ cd /etc/ && tar czf SSL_BACKUP.tar.gz letsencrypt/ && mv SSL_BACKUP.tar.gz /home/user && rm -f SSL_BACKUP.tar.gz

  # Run this script once to save current files then set up a cron job
  # to automatically check and renew certificates
  
  # $ crontab -e

  # # Check if SSL certificate needs to be renewed everyday at 3AM
  # 0 3 * * * certbot renew --post-hook "systemctl restart nginx && /root/SSL_BACKUP.sh"

  ssl_session_timeout 1d;
  ssl_session_cache shared:MozSSL:10m; # about 40000 sessions
  ssl_session_tickets off;

  # $ curl https://ssl-config.mozilla.org/ffdhe2048.txt > /path/to/dhparam
  # ssl_dhparam /path/to/dhparam;

  # intermediate configuration
  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
  ssl_prefer_server_ciphers off;

  # HSTS (ngx_http_headers_module is required) (63072000 seconds)
  add_header Strict-Transport-Sec urity "max-age=63072000" always;

  # OCSP stapling (Optional for faster handshake)
  # ssl_stapling on;
  # ssl_stapling_verify on;
  # verify chain of trust of OCSP response using Root CA and Intermediate certs
  # ssl_trusted_certificate /path/to/root_CA_cert_plus_intermediates;

  # replace with the IP address of your resolver
  resolver 1.1.1.1;

  #------ REVERSE PROXY CONFIGURATION -------

  # This could be an IP and/or domain name
  server_name www.example.com example.com;
  
  # Serve static files
  # Use the absolute path to static folder
  root /path/to/static-files/directory;

  location / {
    # If found serve a static file, else redirect to node app
    try_files $uri @nodejs;
  }

  # Upstream
  location @nodejs {
    proxy_redirect off;
    proxy_http_version 1.1;

    # All requests for '/' are passed to any of the servers
    # listed in the upstream <insert_name> object.
    proxy_pass http://nodejs;

    # Pass data AS SEEN BY NGINX to the NODE APP
    proxy_set_header Host $host;

    # Request headers
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    # Client IP (for analytics or recommendations)
    proxy_set_header X-Real-IP $remote_addr;
  }
}
```

Nginx comes with a default .conf file which we could edit, however we are going to write a separate configuration file. If our configarution fails, it will fallback on the default .conf and handle any errors.

```bash
touch /etc/nginx/conf.d/<insert-name>.conf
```

Test nginx after every modification to .conf files
```sh
nginx -t
```

If successful, restart
```sh
systemctl restart nginx
```

## Serve static files with Nginx

You can server static files using Node.js, however Nginx performs this function much, much faster. 

- Check that nginx can execute/cd into the static folder
- give nginx the permission to read the static folder
```sh
namei -om /absolute/path/to/static/folder
```
- `namei`: Follow a pathname until a terminal point is found.
- `-m`: show the mode bits of each file
- `-o`: show owner and group name of each file

Here is an example: 
```sh
# Output
namei -om /home/mike/myNginx/public/
f: /home/mike/myNginx/public/
 dr-xr-xr-x root root /
 drwxr-xr-x root root home
 drwx------ mike mike mike
 drwxrwxr-x mike mike myNginx
 drwxrwxr-x mike mike public
```

You must modify the permissions for the following directory: 
```sh

drwx------ mike mike mike

# If the permissions on the absolute path do not
# allow nginx to reach the folder do this:

# Change the group of problematic directory for
# to nginx
chowm user:nginx /path/to/folder
# chown : change file owner and group

# Give the nginx group permission to execute
chmod g+x /path/to/static/folder
# chmod : change file mode bits
# g : group
# +x : add permission to execute

# Fixed example outputs:
chown mike:nginx /home/mike
chmod g+x /home/mike/
namei -om /home/mike/myNginx/public/
f: /home/mike/myNginx/public/    
 dr-xr-xr-x root root  /
 drwxr-xr-x root root  home      
 drwx--x--- mike nginx mike      
 drwxrwxr-x mike mike  myNginx   
 drwxrwxr-x mike mike  public  

# Notice how mike's directory changed from
drwx------ mike nginx mike
# to 
drwx--x--- mike nginx mike
```

### Generate SSL certificates using certbot

The `--webroot` authentication method stores a file in the public folder of your app and tries to retrieve it in their end on port 80 of your server. If the file can be retrieved you have proved to be the owner of the domain.

```bash
$ certbot certonly --webroot -d <insert-domain.com> -w /path/to/static-files/directory
```
- `certonly`: Generate the ssl_certificate and ssl_certificate_key without making any changes to our .conf file
- `--webroot`: 
- `-d`: Domain
- `-w`: Absolute path to the static folder of your app. 



  Fill in the <insert-domain.com> as seen below
  $ vim /etc/nginx/conf.d/yourNginx.conf

```sh
certbot certonly --webroot -d <insert-domain.com> -w /path/to/public/directory
```


### Schedule a task using crontab

```sh
crontab -e
```

Check crontab log file
```sh
tail /var/log/cron
```
