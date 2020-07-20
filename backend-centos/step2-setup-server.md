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
In Amazon Linux you should see: `ID_LIKE="rhel fedora"`.

Update your EC2 instance
```sh
yum -y update
```
- `-y`: Don't ask for confirmation

Install **nano**
```sh
yum install -y nano
```

Install **firewalld**
```sh
dnf install firewalld
```

start firewalld automatically on system restart
```sh
systemctl start nginx && \
systemctl enable nginx && \
systemctl status nginx
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

[Extra Packages for Enterprise Linux (EPEL)](https://fedoraproject.org/wiki/EPEL#Quickstart)

RHEL/CentOS 8:
```sh
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
```
on RHEL 8 it is required to also enable the codeready-builder-for-rhel-8-*-rpms repository since EPEL packages may depend on packages from it:
```sh
yum install -y subscription-manager \
ARCH=$( /bin/arch ) \
subscription-manager repos --enable "codeready-builder-for-rhel-8-${ARCH}-rpms"
```
certbot
```sh
dnf install -y certbot python3-certbot-nginx
```

Install **Git**
```sh
yum install -y git
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

Verify you have the following programs are installed
```sh
yum list installed | egrep 'net-tools|nodejs|yarn|gcc-c++|nginx|certbot|git'
```

---

**Installations combined for CentOS**
```sh
yum -y update && \
curl -sL https://rpm.nodesource.com/setup_14.x | bash - && \
curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
yum install -y nodejs git gcc-c++ make nginx certbot yarn && \
yarn global add pm2 && \
systemctl start nginx && \
systemctl enable nginx && \
yum list installed | egrep 'net-tools|nodejs|yarn|gcc-c++|nginx|certbot|git' && \
systemctl status nginx
```

Log in as non-root user and confirm PM2 is installed

```sh
pm2 -v
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

Open port :80 (HTTP)

```sh
firewall-cmd --zone=public --add-service=http --permanent
```

Open port :443 (HTTPS)

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

