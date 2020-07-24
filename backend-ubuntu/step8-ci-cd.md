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

Add the jenkins public key `id_rsa.pub`
```sh
nano ~/.ssh/authorized_keys
```

SSH into your host server as the jenkins user to save your host server in the jenkins' `known_hosts` file

```sh
jenkins@jenkins.example.com:~$ ssh user@example.com
```

Enter `yes` to add host server to known hosts

Go to your jenkins web interface and add the script to be execute through remote SSH in your host server

```
ssh user@example.com<<EOF
  cd ~/myWebApp
  git pull origin master
  yarn install
  pm2 restart all
  exit
EOF
```

# TODO

How do I achieve zero downtime deployment using PM2 and jenkins?

Blue-Green Deployment?