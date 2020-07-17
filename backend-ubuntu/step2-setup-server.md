SSH into server

```sh
ssh [insert-user]@[insert-ip]
```
To login for the first time in DigitaOcean use `root` as user.

## Update and install

Become root to setup server faster without sudo
```sh
sudo su
```

If you're following this tutorial for another Linux distribution, run this command to see what kind of distro you're running.
```sh
cat /etc/*release | grep 'ID_LIKE'
```
In Ubuntu you should see: `ID_LIKE="debian"`.

Update and upgrade Ubuntu instance
```sh
apt update && apt upgrade -y
```
- `-y`: Don't ask for confirmation

Install **net-tools**
```sh
apt install -y net-tools
```

Install **nginx**
```sh
apt install -y nginx
```

Start nginx automatically on system restart
```sh
systemctl start nginx && \
systemctl enable nginx && \
systemctl status nginx
```

Install **certbot**
```sh
apt-get install software-properties-common && \
add-apt-repository universe && \
apt-get update && \
apt-get install certbot python3-certbot-nginx -y
```

Install **Git**
```sh
apt install git
```

Install **Node.js**

```sh
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
apt-get install -y nodejs
```

Install **Development tools** (for Node.js)
```sh
apt-get install -y gcc g++ make
```

Install **Yarn**

```sh
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn
```

**Yarn** is a faster and improved alternative to NPM.

Install **PM2**
```sh
yarn global add pm2
```

Verify you have the following programs are installed
```sh
apt list --installed | egrep 'net-tools|nodejs|yarn|gcc-c++|nginx|certbot|git'
```

---

**Installations combined for Ubuntu**
```sh
apt update && apt upgrade -y && \
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
apt-get install software-properties-common && \
add-apt-repository universe && \
apt-get update && \
apt install -y nodejs net-tools nginx git gcc g++ make certbot python3-certbot-nginx yarn && \
apt list --installed | egrep 'net-tools|nodejs|yarn|gcc-c++|nginx|certbot|git' && \
yarn global add pm2 && \
systemctl start nginx && \
systemctl enable nginx && \
systemctl status nginx
```

Log in as non-root user and confirm PM2 is installed

```sh
pm2 -v
```