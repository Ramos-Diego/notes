[Create a new project and setup github webhook and access token for the project](https://medium.com/@ricardo_fideles/how-to-deploy-a-nodejs-app-with-jenkins-ci-cd-at-digital-ocean-bb44ddd7de2d)

SSH into your jenkins server and switch to the jenkins user
```sh
ssh root@jenkins.example.com
```
```sh
su -l jenkins
```

Generate SSH key pair
```sh
ssh-keygen -t rsa -b 4096
```

SSH into your host server and switch to the non-root user

```sh
ssh root@example.com
```
```sh
su -l user
```

Copy the jenkins public key
```
cat ~/.ssh/id_rsa.pub
```

Paste the jenkins public key `id_rsa.pub`
```sh
nano ~/.ssh/authorized_keys
```

If this file doesn't exist in the host server, run this

```sh
mkdir ~/.ssh && \
chmod 700 ~/.ssh && \
touch ~/.ssh/authorized_keys && \
chmod 600 ~/.ssh/authorized_keys
```

SSH into your host server as the jenkins user to save your host server in the jenkins' `known_hosts` file

```sh
jenkins@jenkins.example.com:~$ ssh user@example.com
```

Enter `yes` to add host server to known hosts

---
GitHub SSH access for host server

Generate public and private keys for the host server
```sh
ssh-keygen -t rsa -b 4096
```

Copy the public key and paste it on Github https://github.com/settings/ssh/new
```
cat ~/.ssh/id_rsa.pub
```

Test SSH communication
```sh
git clone git@github.com:username/app.git
```

---

To run app with zero downtime using PM2 

Run the app in cluster mode
```sh
pm2 start app.js --name example.com -i max
```

Whenever you're deploying to your host server, do NOT `restart`, use `reload` instead.

Example script setup in jenkins
```sh
ssh user@example.com<<EOF
  cd ~/example.com
  git pull origin master
  yarn install
  pm2 reload example.com
  exit
EOF
```