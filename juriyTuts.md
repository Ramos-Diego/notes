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
