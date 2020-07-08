https://stackoverflow.com/questions/44946270/er-not-supported-auth-mode-mysql-server

https://askubuntu.com/questions/172514/how-do-i-uninstall-mysql
sudo apt-get purge mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-* && \
sudo rm -rf /etc/mysql /var/lib/mysql && \
sudo apt-get autoremove && \
sudo apt-get autoclean


https://medium.com/technoetics/installing-and-setting-up-mysql-with-nodejs-in-ubuntu-75e0c0a693ba

sudo apt-get update && \
sudo apt-get install mysql-server && \
sudo systemctl start mysql && \
sudo systemctl enable mysql && \
sudo systemctl status mysql



https://www.w3schools.com/nodejs/nodejs_mysql.asp

## Install mysql in Amazon Linux

```sh
yum update

wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm

yum localinstall mysql57-community-release-el7-11.noarch.rpm 

yum install mysql-community-server

systemctl start mysqld

#Persist service
systemctl enable mysqld

sudo grep 'temporary password' /var/log/mysqld.log
#OUTPUT
#2019-08-31T09:30:06.527923Z 1 [Note] A temporary password is generated for root@localhost: 0+,orlwf3ra

```

### Configure mysql

```sh
mysql_secure_installation
```

Enter new password for root

Remove anonymous users? (Press y|Y for Yes, any other key for No) : y

Disallow root login remotely? (Press y|Y for Yes, any other key for No) : y

Remove test database and access to it? (Press y|Y for Yes, any other key for No) : y

Reload privilege tables now? (Press y|Y for Yes, any other key for No) : y

### Setup remote access

mysql by default only allows connections on localhost

```
vim /etc/my.cnf
```

Add line

`bind-address=YOUR-SERVER-IP or 0.0.0.0`

```sh
systemctl restart mysql
```

### Enter mysql

```bash
mysql -u root -p
```

### Setup a user

```bash
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';

GRANT ALL ON *.* TO jeff@<YOUR-OWN-IP> IDENTIFIED BY "<INSERT_PASSWORD>";

GRANT ALL ON *.* TO jeff@172.58.236.226 IDENTIFIED BY '%iseR/*u:8Ac';

FLUSH PRIVILEGES;

# Only grant access to a specific database
CREATE DATABASE test;

GRANT ALL ON test.* TO jeff@<YOUR-OWN-IP> IDENTIFIED BY "<INSERT_PASSWORD>"
```