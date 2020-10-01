# Configure Jenkins-GitHub SSH connections

By the end of the tutorial you will be able to establish the following SSH connections

- JENKINS SERVER -> HOST SERVER
- JENKINS SERVER -> GITHUB
- HOST SERVER -> GITHUB

These are necessary to access private GitHub repos from the jenkins and the host servers. It will also allow the jenkins server to remotely execute commands in the host server through SSH. 

SSH into your `jenkins server` and switch to the jenkins user

```sh
ssh root@jenkins.example.com
```

```sh
root@jenkins.example.com:~$ su -l jenkins
```

Verify that `authorized_keys` exists

```sh
jenkins@jenkins.example.com:~$ cat ~/.ssh/authorized_keys
```

If this file doesn't exist in the host server, create it and setup the following permissions

```sh
mkdir ~/.ssh && \
chmod 700 ~/.ssh && \
touch ~/.ssh/authorized_keys && \
chmod 600 ~/.ssh/authorized_keys
```

Generate SSH key pair

```sh
jenkins@jenkins.example.com:~$ ssh-keygen -t rsa -b 4096
```

---
Repeat the same process for the host server

```sh
ssh root@example.com
```

```sh
root@example.com:~$ su -l non-root-host-user
```

Verify that `authorized_keys` exists

```sh
non-root-host-user@example.com:~$ cat ~/.ssh/authorized_keys
```

If this file doesn't exist in the host server, create it and setup the following permissions

```sh
mkdir ~/.ssh && \
chmod 700 ~/.ssh && \
touch ~/.ssh/authorized_keys && \
chmod 600 ~/.ssh/authorized_keys
```

Generate SSH key pair

```sh
non-root-host-user@example.com:~$ ssh-keygen -t rsa -b 4096
```

---

## Copy the `jenkins` user's public key
```
jenkins@jenkins.example.com:~$ cat ~/.ssh/id_rsa.pub
```

Paste the jenkins public key `id_rsa.pub` in the host server
```sh
non-root-host-user@example.com:~$ nano ~/.ssh/authorized_keys
```

Open GitHub in the browser and go to Settings > SSH and GPG Keys > Press [new SSH key](https://github.com/settings/ssh/new)


- Title: `jenkins.example.com`

- Key: Paste the jenkins public key `id_rsa.pub`

---

## Copy the `non-root-host-user`'s public key
```
non-root-host-user@example.com:~$ cat ~/.ssh/id_rsa.pub
```

Open GitHub in the browser and go to Settings > SSH and GPG Keys > Press [new SSH key](https://github.com/settings/ssh/new)


- Title: `example.com`

- Key: Paste non-root-host-user's public key `id_rsa.pub`

---


Test SSH communication

JENKINS SERVER -> HOST SERVER

```sh
jenkins@jenkins.example.com:~$ ssh non-root-host-user@example.com
```

JENKINS SERVER -> GITHUB

```sh
jenkins@jenkins.example.com:~$ git clone git@github.com:username/app.git
```

HOST SERVER -> GITHUB

```sh
non-root-host-user@example.com:~$ git clone git@github.com:username/app.git
```

---

## Create a CI/CD project in jenkins

Open your GitHub repository and go to Settings > Webhook

`https://github.com/username/someRepo/settings/hooks`

  - Payload URL: `https://jenkins.example.com/github-webhook/`
  - Content type: `application/x-www-form-urlencoded`
  - Secret: `[Leave empty]`
  - Which events would you like to trigger this webhook?: Just the push event. `[checked]`
  - Active: We will deliver event details when this hook is triggered. `[checked]`

Create a new item in jenkins: `https://jenkins.example.com/view/all/newJob`

Source Code Management

  - Git `[checked]`

    - Repository URL: `git@github.com:username/someRepo.git`
    - Credentials: `[Leave empty]`

Build Triggers

  - GitHub hook trigger for GITScm polling: `[checked]`

Build

  - Execute shell 
    ```
    # TEST APP IN JENKINS
    git pull origin master
    yarn install

    # DEPLOY APP IN HOST SERVER
    ssh user@example.com<<EOF
      cd ~/example.com
      git pull origin master
      yarn install
      pm2 reload example.com
      exit
    EOF
    ```

To run app with zero downtime using PM2 run the app in cluster mode

```sh
pm2 start app.js --name example.com -i max
```

Whenever you're deploying to your host server, do **NOT** `restart`, use `reload` instead.
