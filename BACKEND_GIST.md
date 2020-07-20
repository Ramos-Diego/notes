# Securely deploy and mantain Node.js apps

Even though AWS has tools such as Elastic Beanstalk, which automates and enables our apps to be managed using a GUI, by performing a manual setup you gain a better understanding of Elastic Beastalk and the ability to deploy an app from any other service provider. You could even follow these steps to run an app in a Raspberry Pi. The sky is the limit.

STEP BY STEP

1. Launch server (AWS), buy domain and setup DNS (NameCheap).
2. Install all the software (nodejs, yarn, gcc-c++, docker, docker-compose, nginx, certbot)
3. Run custom docker-compose
4. Setup certbot autorenewal

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

- Create an EC2 instance and download the key pair to SSH into it.
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

### Setup your local computer to connect through SSH

Note: If you're using Windows 10 you will need WSL to run some command locally.

[Install WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

Save the `.pem` file that you downloaded when creating the EC2 instance in a safe location in your local machine. 

Change the SSH key's permissions

```sh
chmod 400 /path/to/key.pem
```

I recommend you setup an alias in your local machine to remote into your server. Note that the default SSH usernames for EC2 instances changes depending on the distro.

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
    chmod 753 =  7   5   3              lrwx---rwx
```

### Note

I will provide examples in Amazon Linux 2 and Ubuntu because these derive from Debian and REHL, which are the type of Linux distributions you're most likely to use on your server.

If your server is runnin Ubuntu, you will use `apt-get` instead of `yum` as a package manager and `AppArmor` instead of `SELinux` to secure the server.

Use this command to know what kind of Linux distro you're using:

```sh
cat /etc/*release | grep 'ID_LIKE'
# OUTPUT for Amazon Linux 2
# ID_LIKE="centos rhel fedora"
```

Become `root` to setup the server
```sh
sudo su
```

If you're not `root` you will need to preceed all commands with `sudo`.

---

**Update and upgrade your linux OS**

*Amazon Linux*
```sh
yum -y update
```
- `-y`: Don't ask for confirmation

*Ubuntu*
```sh
sudo apt-get update && sudo apt-get upgrade -y
```

TODO: What does the dev tools contian?

**Install Development Tools**

*Amazon Linux*
```sh
yum -y groupinstall "Development Tools"
```

*Ubuntu*
```sh
sudo apt-get install net-tools build-essential
```

**Verify that you have Vim and net-tools installed**
```sh
yum list installed | egrep 'vim|net-tools'
```

### Install Node.js

[*Amazon Linux*](https://github.com/nodesource/distributions/blob/master/README.md#installation-instructions-1)
```sh
curl -sL https://rpm.nodesource.com/setup_14.x | bash -
```

[*Ubuntu*](https://github.com/nodesource/distributions/blob/master/README.md#installation-instructions)
```sh
curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt-get install -y nodejs
```

### Install yarn

Yarn is a faster and improved alternative to NPM.

[*Amazon Linux*](https://classic.yarnpkg.com/en/docs/install/#centos-stable)
```sh
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
```
```sh
yum install yarn
```

[*Ubuntu*](https://classic.yarnpkg.com/en/docs/install/#debian-stable)
```sh
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
```
```sh
sudo apt update && sudo apt install -y yarn
```

### Install [PM2](https://pm2.keymetrics.io/docs/usage/pm2-doc-single-page/#installation)

*yarn*
```sh
yarn global add pm2
```
*npm*
```sh
npm install pm2@latest -g
```

Once the server has been setup, we need to create a non-root user. You should not run any app that can access the internet as root.

---

### Configure non-root user

Add an user
```sh
adduser <insert-username>
```

Make the user an admin by adding to [**wheel**](https://www.wikiwand.com/en/Wheel_(computing)) group (Optional)
```sh
usermod -aG wheel <insert-username>
```
- `-G, --groups GROUPS`: new list of supplementary GROUPS
- `-a, --append`: append the user to the supplemental GROUPS mentioned by the -G option without removing the user from other groups

See what groups the user is added to
```sh
groups
```

Switch to someUser
```sh
sudo su - <insert-username>
```

Verify you're using the right user
```sh
whoami
```

### Set up keys to connect without password
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

**All in one command**
```sh
mkdir ~/.ssh && \
chmod 700 ~/.ssh && \
touch ~/.ssh/authorized_keys && \
chmod 600 ~/.ssh/authorized_keys && \
ls -lRa ~/. | egrep '.ssh|authorized_keys'
```

---

For the sake of this tutorial we will zip our app and send it to the server using SSH. In a more advance setup this could be automated such that upon a commit to github the app gets updated in the server. Learn more about CI/CD.  

### Compress your app
```sh
tar czf <FILENAME>.tar.gz -X .gitignore .
```
- `c`: create a new archive
- `z`: filter the archive through **gzip**
- `f`: use archive file or device ARCHIVE
- `-X`: exclude patterns listed in FILE

**WARNING:** Trailing slashes at the end of excluded folders will cause tar to NOT exclude those folders at all. This is specially important because you want to ignore the `/node_modules` directory.

`.gitignore` example:

```sh
# Dependency directories
node_modules

# dotenv environment variables file
.env
```


Tranfer files from the local machine to the server
```sh
sudo scp -i keys.pem <FILENAME>.tar.gz <USER>@<EC2 PUBLIC IP>:~
```
Remember that `~` refers to the home directory

SSH into your server and extract your app
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

To make sure your app will persist upon reboot, restart EC2 instance (DANGER)
```sh
reboot
```

or

```bash
shutdown -r now
```

We can automate the process of zipping and transferring the file to our server by creating a **deploy script**:

```sh
vim deploy.sh
```

```sh
#!/bin/bash

# Compress all the necessary files
tar czf <FILENAME>.tar.gz -X .gitignore .

# Transfer files to EC2 instance
sudo scp -i <key-name>.pem <filename>.tar.gz ec2-user@<EC2-public-ip>:~
# -i : Insert private key file

# Remove the .tar.gz file from local PC
rm <filename>.tar.gz

# ---------------------------------------

# Run commands remotely
ssh ec2-user@<EC2-public-ip> << 'ENDSSH'
# Stop PM2 app
pm2 stop <app-name>

# Delete current version of the app
rm -rf <app-directory>

# Create new app directory
mkdir <new-app-directory>

# Unzip .tar.gz file
tar xf <ANYFILE>.tar.gz -C <new-app-directory>

# Install dependencies
cd <new-app-directory>
yarn install

# restart app
pm2 start <new-app-name>
ENDSSH
```

---

## SELinux

SELinux is a Linux kernel security module that provides a mechanism for supporting access control security policies. It is known to be complicated, but you don't need to know all the details to use it.

Amazon Linux 2 does not enfore SELinux by default.

SELinux configuration [article](https://www.digitalocean.com/community/tutorials/an-introduction-to-selinux-on-centos-7-part-1-basic-concepts), [video](https://www.youtube.com/watch?v=HhydNtaLEK0&list=PLQlWzK5tU-gDyxC1JTpyC2avvJlt3hrIh&index=9)

Check if SELinux is installed and enforced
```sh
getenforce
# Expected output:
# enforcing OR permissive OR disabled
```


Allow HTTP servers to connect to other backends
```sh
setsebool -P httpd_can_network_connect on
```
- `-P`: persist change

Allow HTTP servers to read files from user home directory
```sh
setsebool -P httpd_enable_homedirs on
```

Change the context of the static folder and its files to be accessible. In other words, enable your static files to be served by **Nginx**.

```sh
chcon -Rt httpd_sys_content_t /path/to/static_folder
```
- `-R`: Recursive change
- `-t`: Change directory/file TYPE

**SELinux debugging**

Set SELinux to `enforce` mode
```sh
setenforce 1
```

Set SELinux to `permissive` mode. This mode only logs the output from SELinux, thus it can be used to debug your setup. If you make SELinux `permissive` and your app works as it should you need to check your policies.
```sh
setenforce 0
```

Check the context details for files and directories
```sh
ls -lZ
```

Check context of current processes
```sh
ps auxZ | grep nginx
```

AppArmor is the Ubuntu equivalent to SELinux.


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

### Generate SSL certificates using certbot

The `--webroot` authentication method stores a file in the public folder of your app and tries to retrieve it in their end on port 80 of your server. If the file can be retrieved you have proved to be the owner of the domain.

```bash
certbot certonly --webroot -d <insert-domain.com> -w /home/<insert-non-root-user>/webroot
```
- `certonly`: Generate the ssl_certificate and ssl_certificate_key without making any changes to our .conf file
- `--webroot`: Place files in a server's webroot folder for authentication 
- `-d`: Comma-separated list of domains to obtain a certificate for
- `-w`: Absolute path to the static folder of your app. 


### Automatically renew your SSL certificates using `crontab`

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
0 3 * * * certbot renew --post-hook "systemctl reload nginx && /root/SSH_BACKUP.sh"
```

Check crontab log file
```sh
less /var/log/cron | grep certbot
```

---
### Network intefaces


Interface configuration
```sh
ifconfig 
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
This command is really important when debugging your application. Whenever you can't reach your app, check your ports. 

---

