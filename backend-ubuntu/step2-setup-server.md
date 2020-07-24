SSH into server

```sh
ssh [insert-user]@[insert-ip-OR-example.com]
```
To login for the first time in DigitaOcean use `root` as user.

## Update and install

Become root to setup server faster without sudo
```sh
sudo su
```

Update and upgrade Ubuntu instance
```sh
apt update && apt upgrade -y
```
- `-y`: Don't ask for confirmation

Check if system needs to be restarted

```sh
cat /var/run/reboot-required
```
If the file doesn't exist, you don't need to restart Ubuntu.

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
apt install -y certbot 
```

Install **Git**
```sh
apt install -y git
```

Install **Node.js**

```sh
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
apt install -y nodejs
```

Install **Development tools** (for Node.js)
```sh
apt install -y gcc g++ make
```

Install **Yarn**

```sh
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
apt update && apt install -y yarn
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
sudo apt update
apt install -y nodejs net-tools nginx git gcc g++ make certbot yarn && \
yarn global add pm2 && \
systemctl start nginx && \
systemctl enable nginx && \
systemctl status nginx
```