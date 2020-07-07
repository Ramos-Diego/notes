Check the operating system you're working with:

```sh
lsb_release -a
```

- Create an EC2 instance and download the key pair to ssh into it.
- Associate an Elastic IP to the instance

```
Right click on instance > Networking > Change security groups > [Simply note the instance's security group]
EC2 Dashboard > Network and Security > Security Groups > [Select the instance's security group] > 
Inbound rules > Edit inbound rules > Add Rule > Fill the fields according to this table
```

EC2 > Security Groups 

| Type  | Protocol | Port range | Source (CIDR blocks) | Description   |
|-------|----------|------------|----------------------|---------------|
| HTTP  | TCP      | 80         | 0.0.0.0/0            | HTTP          |
| SSH   | TCP      | 22         | 1.2.3.4/24           | ADMIN IP ONLY |
| HTTPS | TCP      | 443        | 0.0.0.0/0            | HTTPS         |

- If working on Windows

Move the .pem file you got from the AWS EC2 instance somewhere in the [C: drive](https://stackoverflow.com/questions/39404087/pem-file-permissions-on-bash-on-ubuntu-on-windows).

```sh
chmod 400 /path/to/key.pem
```

- Become root to setup server faster without sudo
```sh
sudo su
```
- Go back to user
```sh
exit
```

If you're not root you will need to preceed the commands with `sudo`

- Update and upgrade your linux OS

```sh
# Amazon Linux
yum -y update
# -y : Don't ask for confirmation

# Ubuntu
sudo apt-get update && sudo apt-get upgrade -y
# -y : Don't ask for confirmation
```

- Install yum Development Tools
```sh
# Amazon Linux
yum -y groupinstall "Development Tools"
```

- Verify that you have Vim and net-tools installed
```sh
yum list installed | egrep 'vim|net-tools'
```

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

# Using Ubuntu
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# Using Debian, as root
curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt-get install -y nodejs
```
- Install global tools

```sh
npm install -g pm2
```

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
- Configure non-root user?
```sh
# Add a user
adduser someUser

# Make user an admin by adding to 'wheel' group (Optional)
usermod -aG wheel someUser

# See what groups the user is added to
groups

# Switch to someUser
sudo su - someUser

# See what user you're using
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

- Compress project files
```sh
tar czf <FILENAME>.tar.gz file1 file2 file3
```

- Tranfer files between local machine and EC2 instance
```sh
sudo scp -i keys.pem <FILENAME>.tar.gz <USER>@<EC2 PUBLIC IP>:~
```
- Extract tar file
```sh
tar xf <FILENAME>.tar.gz
```
- Run app with PM2

```sh
pm2 start --name someApp app.js
```

- Start PM2 on instance restart

```sh
pm2 startup
#FOLLOW THE INSTRUCTIONS PROVIDED BY PM2
```

- Restart EC2 instance (DANGER)
```sh
shutdown -r now
# or
reboot
```

- Create a deploy script

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

- Start Nginx

```sh
# Startup and system management for Amazon Linux
systemctl start nginx
# systemctl : Control the systemd system and service manager

# Check status
systemctl status nginx

# Make Nginx persistant on restart
systemctl enable nginx

# Edit Nginx config file
vim /etc/nginx/nginx.conf

# Create separate configuration file
touch /etc/nginx/conf.d/myConf.conf
```

- Test nginx after every modification to .conf files

```sh
nginx -t

# If successful, restart
systemctl restart nginx
```

- Make Nginix serve static files

```sh
# Check that nginx can execute/cd into the static folder
# give nginx the permission to read the static folder
namei -om /absolute/path/to/static/folder
# namei: Follow a pathname until a terminal point is found.
# -m : show the mode bits of each file
# -o : show owner and group name of each file

# Output
namei -om /home/mike/myNginx/public/
f: /home/mike/myNginx/public/
 dr-xr-xr-x root root /
 drwxr-xr-x root root home
 drwx------ mike mike mike
 drwxrwxr-x mike mike myNginx
 drwxrwxr-x mike mike public

# Must modify the permissions for 
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

CERTBOT

```sh
certbot certonly --webroot -d <insert-domain.com> -w /path/to/public/directory
```


- crontab

```sh
crontab -e

# Check crontab log file
tail /var/log/cron
```