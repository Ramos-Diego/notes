# Install software in your server

Now that you have an Ubuntu server running you need to install Node.js, yarn, nginx, certbot, git and other tools in order to have a CI/CD setup.

SSH into your server

```sh
ssh [insert-user]@[insert-ip-OR-your-domain.com]
```
To login for the first time in DigitaOcean use `root` as user.

## Install the required software

Become root to easily install all the software.

```sh
sudo su
```

Before installing any package Update Ubuntu and reboot your server. This will ensure that you are downloading the latest and greatest version of all the programs.

```sh
apt update && \
apt upgrade -y && \
reboot
```

Check if system still needs to be restarted.

```sh
cat /var/run/reboot-required
```

If the file doesn't exist, you don't need to restart Ubuntu.

Install **net-tools**. This program provides network monitoring tools.

```sh
apt install -y net-tools
```

Install **nginx**, a web server that can also be used as a reverse proxy. It is a key component of this setup.

```sh
apt install -y nginx
```

Use `systemctl`, a linux system manager, to start nginx automatically on system restart
```sh
systemctl start nginx && \
systemctl enable nginx && \
systemctl status nginx
```

Install **certbot**, it provides SSL certification tools.
```sh
apt install -y certbot 
```

Install **Git**. Git is a distributed version-control system for tracking changes in source code. It is needed to use GitHub.
```sh
apt install -y git
```

Install **Node.js**.

```sh
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
apt install -y nodejs
```

I chose Node 14, but you can choose any version of Node.js from [here](https://github.com/nodesource/distributions/blob/master/README.md).

Install **Development tools** (for Node.js).
```sh
apt install -y gcc g++ make
```

Install **Yarn**, a much faster and better alternative to the Node Package Manager (NPM).

```sh
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
apt update && apt install -y yarn
```

Install **PM2**, a process manager that allows for 0-downtime deploys with multicore servers.

```sh
yarn global add pm2
```

Verify that the following programs are installed

```sh
apt list --installed | egrep 'net-tools|nodejs|yarn|gcc-c++|nginx|certbot|git'
```

---

If you feel like you've messed up at some point you can use these chained commands to run all the installations at once.

### Installations combined for Ubuntu

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

Check if you need to restart your server after these installations.
