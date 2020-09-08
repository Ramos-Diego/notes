## 2. Install software

```sh
ssh [insert-user]@[insert-ip-OR-your-domain.com]
```
To login for the first time in DigitaOcean use `root` as user.

### Install the required software

Become root to easily enter the commands.
```sh
sudo su
```

Update Ubuntu and reboot

```sh
apt update && \
apt upgrade -y && \
reboot
```

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

You can choose any version of Node.js from [here](https://github.com/nodesource/distributions/blob/master/README.md).

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

Verify that the following programs are installed
```sh
apt list --installed | egrep 'net-tools|nodejs|yarn|gcc-c++|nginx|certbot|git'
```

---

You can chain these commands to run all the installations at once.

**Installations combined for Ubuntu**
```sh
apt update && apt upgrade -y && \
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
apt update && \
apt install -y nodejs net-tools nginx git gcc g++ make certbot yarn && \
yarn global add pm2 && \
systemctl start nginx && \
systemctl enable nginx && \
systemctl status nginx
```