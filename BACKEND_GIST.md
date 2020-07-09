# Securely deploy and mantain Node.js apps

Even though AWS has tools such as Elastic Beanstalk which automates and enables our apps to be managed using a GUI, by performing a manual setup you gain a better understanding of Elastic Beastalk and the ability to deploy an app from any other service provider. You could even follow these steps to run an app in a Raspberry Pi. The sky is the limit.

## Topics

- Amazon Web Services (AWS)
- PM2
- Nginx
- Reverse proxy
- SSL certificates and HTTPS
- Cronjobs (Scheduled tasks)
- SELinux

### Launch EC2 instance

Once our app is ready for deployment follow these steps:

- Create an EC2 instance and download the key pair to ssh into it.
- Associate an Elastic IP to the instance

Open PORT 22 and add your IP to be able to SSH into the EC2 instance.

```
Right click on instance > Networking > Change security groups > [Simply note the instance's security group]
EC2 Dashboard > Network and Security > Security Groups > [Select the instance's security group] > 
Inbound rules > Edit inbound rules > Add Rule > Fill the fields according to this table
```

You can also open PORT 80 (HTTP) and 443 (HTTPS) because this will be the setup for the entire project. The result should look like this.

EC2 > Security Groups 

| Type  | Protocol | Port range | Source (CIDR blocks) | Description   |
|-------|----------|------------|----------------------|---------------|
| HTTP  | TCP      | 80         | 0.0.0.0/0            | HTTP          |
| SSH   | TCP      | 22         | 1.2.3.4/24           | ADMIN IP ONLY |
| HTTPS | TCP      | 443        | 0.0.0.0/0            | HTTPS         |

# TODO: RUN COMMAND WITHOUT CALLING THE KEY EVERYTIME

### Setup your local computer to connect through SSH

# TODO: Provide permissions explanation

- Change the SSH key's permissions

This is the `.pem` file that you downloaded when creating the EC2 instance.

```sh
chmod 400 /path/to/key.pem
```
## SSH into your server
```sh
sudo ssh -i EC2.pem ec2-user@<insert-elastic-ip>
```
- `-i`: indicates the SSH key file

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


- Update and upgrade your linux OS

```sh
# Amazon Linux
yum -y update
```
- `-y`: Don't ask for confirmation

```sh
# Ubuntu
sudo apt-get update && sudo apt-get upgrade -y
```
- `-y`: Don't ask for confirmation

TODO: What does the dev tools contian?

- Install yum Development Tools
```sh
# Amazon Linux
yum -y groupinstall "Development Tools"
```

- Verify that you have Vim and net-tools installed
```sh
yum list installed | egrep 'vim|net-tools'
```

### Install Node.js in Amazon Linux 2
- Download the necessary [packages](https://packages.ubuntu.com/) to install Node.js
```sh
sudo apt-get install build-essential
```
- Install net-tools?
```sh
sudo apt-get install net-tools
```
- Install Node.js
**Node.js v14.x**:

```sh
# As root Amazon Linux
curl -sL https://rpm.nodesource.com/setup_14.x | bash -

# Using Ubuntu, as root
curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt-get install -y nodejs
```

### Install PM2

- Install global tools

```sh
npm install -g pm2
```

Yarn is a faster and improved alternative to NPM.

- Install [yarn](https://classic.yarnpkg.com/en/docs/install/#centos-stable)

```sh
# Amazon Linux
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo

yum install yarn

# Ubuntu
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -

echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt update && sudo apt install yarn
```

Once the server has been setup, we need to create a non-root user. This is a security measure that ensures our Node.js app can't be attacked and gain root access on the server.

### Configure non-root user
```sh
# Add a user
adduser someUser

# Make user an admin by adding to 'wheel' group (Optional)
usermod -aG wheel someUser

# See what groups the user is added to
groups

# Switch to someUser
sudo su - someUser

# Verify your user
whoami

# Set up keys to connect without password
mkdir ~/.ssh

# Change folder permissions
# 700: only give access to current user
chmod 700 ~/.ssh

# create new keys file
touch ~/.ssh/authorized_keys

# Change keys permissions
chmod 600 ~/.ssh/authorized_keys

# Verify permissions
ls -lRa ~/. | egrep '.ssh|authorized_keys'
# -l : verbose output
# -R : Recursive mode
# -a : all files 
```

### All in one command

```sh
adduser someUser && \
usermod -aG wheel someUser && \
mkdir ~/.ssh && \
chmod 700 ~/.ssh && \
touch ~/.ssh/authorized_keys && \
chmod 600 ~/.ssh/authorized_keys && \
ls -lRa ~/. | egrep '.ssh|authorized_keys'
```

For the sake of this tutorial we will zip our app and send it to the server using SSH. In a more advance setup this could be automated such that upon a commit to github the app gets updated in the server. Learn more about CI/CD.  

### Compress your app
# TODO: see if you can exclude files instead of adding all
```sh
tar czf <FILENAME>.tar.gz file1 file2 file3
```

### Tranfer files from the local machine to the server

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
pm2 start --name someApp app.js
```

### Persist app upon reboot with PM2

```sh
pm2 startup
```
FOLLOW THE INSTRUCTIONS PROVIDED BY PM2

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

#!/bin/bash

# Compress all the necessary files
tar czf <ANYFILE>.tar.gz serve.js  package.json public README.md
# c : compress, z : zip, f : file

# Transfer files to EC2 instance
sudo scp -i keys.pem <ANYFILE>.tar.gz ec2-user@<EC2 PUBLIC IP>:~
# -i : Insert private key file

# Remove the .tar.gz file from local PC
rm <ANYFILE>.tar.gz

# Run commands remotely
ssh ec2-user@<EC2 PUBLIC IP> << 'ENDSSH'
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

```sh
# Allow HTTP servers to connect to other backends
setsebool -P httpd_can_network_connect on
# -P : persist change

# Allow HTTP servers to read files from user home directory
setsebool -P httpd_enable_homedirs on

# Change the context of the static folder and its files to be accessible
chcon -Rt httpd_sys_content_t /path/to/static_folder
# -R : Recursive change
# -t : Change directory/file TYPE

# Check SELinux mode
getenforce

# SELinux debugging
# Set SELinux to enforce mode
setenforce 1

# Set SELinux to permissive mode
setenforce 0

# Check the context details for files and directories
ls -lZ
# Check context of current processes
ps auxZ
```

- Network intefaces

```sh
# interface configuration
ifconfig 

# Network statistics
netstat

# view open ports using netstat
netstat -tln 
# -t: Only TCP
# -l: Ports that are listening
# -n: IPs as numbers, not hostnames
```

- Install Nginx

```sh
# Extra Packages for Enterprise Linux
yum install -y epel-release 

# epel-release is available in Amazon Linux Extra topic "epel"   
amazon-linux-extras install epel

# Install Nginx
yum install -y nginx 
```

### Start Nginx

With `systemctl` you can control the system manager on REHL and Debian like systems. 


- Start the nginx process
```sh
systemctl start nginx
```
- `start`: Start a process.


```bash
# Check status
systemctl status nginx
```

```bash
# Make Nginx persistant on restart
systemctl enable nginx
```

```bash
# Edit Nginx config file
vim /etc/nginx/nginx.conf
```

Nginx comes with a default .conf file which we could edit, however we are going to write a separate configuration file. If our configarution fails, it will fallback on the default .conf and handle any errors.

```bash
touch /etc/nginx/conf.d/<insert-name>.conf
```

Test nginx after every modification to .conf files

```sh
nginx -t

# If successful, restart
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

# Check crontab log file
tail /var/log/cron
```
