SSH into server

```sh
ssh [insert-user]@[insert-ip-or-domain]
```
To login for the first time in DigitaOcean use `root` as user.

## Update and install

Update your droplet
```sh
dnf -y update
```
- `-y`: Don't ask for confirmation

Install **nano**
```sh
dnf install -y nano
```

Install **firewalld**
```sh
dnf install -y firewalld
```

start `firewalld` automatically on system restart
```sh
systemctl start firewalld && \
systemctl enable firewalld && \
systemctl status firewalld
```

Install **NGINX**
```sh
dnf install -y nginx
```

start `nginx` automatically on system restart
```sh
systemctl start nginx && \
systemctl enable nginx && \
systemctl status nginx
```

Install **certbot**

Extra Packages for Enterprise Linux (EPEL)
```sh
dnf install -y epel-release
```

certbot
```sh
dnf install -y certbot
```

Install **Git**
```sh
dnf install -y git
```

Install **Node.js**
```sh
curl -sL https://rpm.nodesource.com/setup_14.x | bash -
```
```sh
dnf install -y nodejs
```

Install **Development tools** (for Node.js)
```sh
dnf install -y gcc-c++ make
```

Install **Yarn**

```sh
curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo
```
```sh
dnf install -y yarn
```
**Yarn** is a faster and improved alternative to NPM.

Install **PM2**
```sh
yarn global add pm2
```

Verify the following programs are installed
```sh
dnf list installed | egrep 'net-tools|nodejs|yarn|gcc-c++|nginx|make|certbot|git|firewalld'
```

Verify PM2 is installed

```sh
pm2 -v
```
---

**Installations combined for CentOS**
```sh
dnf -y update && \
curl -sL https://rpm.nodesource.com/setup_14.x | bash - && \
curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
dnf install -y certbot firewalld nodejs nano git gcc-c++ make nginx yarn && \
yarn global add pm2 && \
systemctl start nginx firewalld && \
systemctl enable nginx firewalld
```

---

## [Firewalld](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-8)

Check if `firewalld` is running
```sh
firewall-cmd --state
```
or
```sh
systemctl status firewalld
```

Check the current `firewalld` default zone and setup
```sh
firewall-cmd --list-all
```

Open port `:80` (HTTP)

```sh
firewall-cmd --zone=public --add-service=http --permanent
```

Open port `:443` (HTTPS)

```sh
firewall-cmd --zone=public --add-service=https --permanent
```

Reload firewalld to apply changes
```sh
firewall-cmd --reload
```
or
```sh
systemctl reload firewalld
```

Check that changes have been applied
```sh
firewall-cmd --zone=public --list-services --permanent
```

Check open ports

```sh
ss -tln
```

Correct output should be 

--- 

Open custom ports for testing purposes 

```sh
firewall-cmd --zone=public --add-port=5000/tcp
```

Check that changes have been applied (Not permanent)
```sh
firewall-cmd --zone=public --list-ports
```

