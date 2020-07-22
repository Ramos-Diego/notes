Jenkins should be setup in a seprate server. 

Setup everything in the server except for the application itself and PM2, then follow these steps

[Official guide](https://www.jenkins.io/doc/book/installing/#long-term-support-release)

Become root to setup server faster without sudo
```sh
sudo su
```

Check if Java is installed 

```sh
java -version
```

Expected output
```sh
openjdk version "1.8.0_252"
OpenJDK Runtime Environment (build 1.8.0_252-8u252-b09-1ubuntu1-b09)
OpenJDK 64-Bit Server VM (build 25.252-b09, mixed mode)
```

Install Java
```sh
sudo apt update && \
apt install -y openjdk-8-jdk && \
```

Install Jenkins
```sh
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add - && \
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list' && \
sudo apt-get update && \
sudo apt-get install -y jenkins
```

Update Ubuntu and reboot

```sh
apt update && \
apt upgrade -y && \
reboot
```

---

**Installations combined for Ubuntu Jenkins server**
```sh
apt update && apt upgrade -y && \
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add - && \
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list' && \
apt install software-properties-common && \
add-apt-repository universe && \
apt update && \
apt install -y nodejs openjdk-8-jdk net-tools nginx git gcc g++ make certbot wget yarn && \
systemctl start nginx && \
systemctl enable nginx && \
systemctl status nginx
```

After installation you need to open port `:8080` for jenkins

```sh
ufw allow 8080/tcp
```
Also allow SSH, HTTP and HTTPS
```sh
ufw allow 'Nginx Full' && \
ufw allow OpenSSH && \
ufw enable && \
ufw status && \
ss -tln
```

It is key that you don't forget to allow OpenSSH before enabling the firewall as you may get permanently locked out of your server.

Setting the JAVA_HOME Environment Variable

Find the installation path for Java
```sh
update-alternatives --config java
```
Create new environmnent variable with the path
```sh
nano /etc/environment
```
```sh
# /etc/environment
JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java"
JRE_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java/jre"
```
Reload enviroment variables
```sh
source /etc/environment
```
Test environment variable
```sh
echo $JAVA_HOME
```
Expected output
```sh
/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
```

---

Setup SSL certificates and NGINX configuartion to connect to open Jenkins in the browser

