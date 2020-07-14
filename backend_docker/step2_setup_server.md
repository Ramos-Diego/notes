## SSH

Change the SSH key permissions

```sh
chmod 400 /path/to/key.pem
```

SSH into EC2 instance for the first time:
```sh
sudo ssh -i /path/to/<SSH-key>.pem ec2-user@<insert-public-ip>
```

Make an alias to SSH into EC2 instance
```sh
echo "alias ec2='sudo ssh -i /path/to/<key-name>.pem ec2-user@<insert-public-ip>'" >> ~/.bash_aliases
```

From this point use the alias to remote into the EC2 instance
```sh
ec2
```

If you make any mistake edit the file
```sh
vim ~/.bash_aliases
```

## Update and install

Become root to setup server faster without sudo
```sh
sudo su
```

If you're following this tutorial for another Linux distribution, run this command to see what kind of distro you're running.
```sh
cat /etc/*release | grep 'ID_LIKE'
```
In Amazon Linux you should see: `ID_LIKE="rhel fedora"`.

Update your EC2 instance
```sh
yum -y update
```
- `-y`: Don't ask for confirmation

```sh
amazon-linux-extras install epel
```

Install **NGINX**
```sh
yum install -y nginx
```

start nginx automatically on system restart
```sh
systemctl start nginx && \
systemctl enable nginx && \
systemctl status nginx
```

Install **certbot**
```sh
yum install -y certbot
```

Install **Node.js**

```sh
curl -sL https://rpm.nodesource.com/setup_14.x | bash -
```
```sh
yum install -y nodejs
```

Install **Development tools** (for Node.js)
```sh
yum install -y gcc-c++ make
```

Install **Yarn**

```sh
curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo
```
```sh
yum install -y yarn
```
**Yarn** is a faster and improved alternative to NPM.

Install **PM2**
```sh
yarn global add pm2
```

Install **Docker**
```sh
amazon-linux-extras install -y docker
```
```sh
yum install -y docker
```
```sh
systemctl start docker && \
systemctl enable docker && \
systemctl status docker
```

Install docker-compose

```sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

Apply executable permissions to the binary
```sh
chmod +x /usr/local/bin/docker-compose
```

Verify you have the following programs are installed
```sh
yum list installed | egrep 'vim|net-tools|nodejs|yarn|gcc-c++|docker|nginx|certbot'
```

---

**Installations combined for AMAZON LINUX 2**
```sh
yum -y update && \
amazon-linux-extras install -y epel docker && \
curl -sL https://rpm.nodesource.com/setup_14.x | bash - && \
curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
yum install -y nodejs gcc-c++ make nginx certbot yarn docker && \
yarn global add pm2 && \
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
chmod +x /usr/local/bin/docker-compose && \
systemctl start docker nginx && \
systemctl enable docker nginx && \
yum list installed | egrep 'net-tools|nodejs|yarn|gcc-c++|docker|nginx|certbot' && \
systemctl status docker nginx | egrep 'Active|docker.service -|nginx.service -'
```

Log in as non-root user and confirm PM2 and docker-compose are installed

```sh
pm2 -v && \
docker-compose -v
```