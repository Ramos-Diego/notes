Jenkins should be setup in a seprate server. 

Setup everything in the server except for the application itself and PM2, then follow these steps

[Official guide](https://www.jenkins.io/doc/book/installing/#long-term-support-release)

Become root to setup server faster without sudo
```sh
sudo su
```

Update Ubuntu and reboot

```sh
apt update && \
apt upgrade -y && \
reboot
```

Check if Java is installed 

```sh
java -version
```

Expected output
```sh
openjdk version "11.0.7" 2020-04-14
OpenJDK Runtime Environment (build 11.0.7+10-post-Ubuntu-3ubuntu1)
OpenJDK 64-Bit Server VM (build 11.0.7+10-post-Ubuntu-3ubuntu1, mixed mode, sharing)
```

Install Java
```sh
sudo apt update && \
apt install -y default-jre
```

Install Jenkins
```sh
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add - && \
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list' && \
sudo apt-get update && \
sudo apt-get install -y jenkins
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

<mark>It's **IMPORTANT** that you don't forget to allow `OpenSSH` before enabling the firewall as you may get permanently locked out of your server.</mark>

Setting the JAVA_HOME Environment Variable

Find the installation path for Java
```sh
update-alternatives --config java
```

```sh
  Selection    Path                                            Priority   Status
------------------------------------------------------------
* 0            /usr/lib/jvm/java-11-openjdk-amd64/bin/java      1111      auto mode
  1            /usr/lib/jvm/java-11-openjdk-amd64/bin/java      1111      manual mode
  2            /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java   1081      manual mode

```
Copy the path for the current choice, marked with *

Create new environmnent variable with the path
```sh
nano /etc/environment
```
```sh
# /etc/environment
JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64/bin/java"
JRE_HOME="/usr/lib/jvm/java-11-openjdk-amd64/bin/java/jre"
```
Reload enviroment variables
```sh
source /etc/environment
```

Make Jenkins listen only on localhost:8080
```sh
nano /etc/default/jenkins
```
Edit `JENKINS_ARGS` and add `--httpListenAddress=127.0.0.1` to it
```sh
JENKINS_ARGS="--webroot=/var/run/jenkins/war --httpPort=$HTTP_PORT --httpListenAddress=127.0.0.1"
```
Restart Jenkins
```sh
systemctl restart jenkins
```
---

Setup SSL certificates and NGINX configuartion then open Jenkins in the browser

