- Create an EC2 instance and download the key pair to ssh into it.
- Associate an Elastic IP to the instance
- Open port 3000

```
Right click on instance > Networking > Change security groups > [Simply note the instance's security group]
EC2 Dashboard > Network and Security > Security Groups > [Select the instance's security group] > 
Inbound rules > Edit inbound rules > Add Rule > Type: Custom TCP > Port Range: 3000 or pick another > Source: Anywhere 
```

- Become root
```sh
sudo su
```
- Go back to user
```sh
exit
```

- Update and upgrade Ubuntu (or whatever your OS is)

```sh
sudo apt-get update && sudo apt-get upgrade -y
```
- Download the necessary [packages](https://packages.ubuntu.com/) to install Node.js
```sh
sudo apt-get install build-essential
```
- Install net-tools?
```sh
sudo apt-get install net-tools
```
- Install Node.js
**Node.js v14.x**:

```sh
# Using Ubuntu
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# Using Debian, as root
curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt-get install -y nodejs
```
- Install global tools

```sh
sudo npm install -g pm2 http-server
```
- Test sample page
```sh
echo "Hello World" > index.html
http-server
```
- Install [yarn](https://classic.yarnpkg.com/en/docs/install/#debian-stable)

```sh
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -

echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt update && sudo apt install yarn
```
- Configure non-root user?

- Tranfer files between local machine and EC2 instance
```sh
sudo scp -i keys.pem <ANYFILE>.tar.gz ubuntu@<EC2 PUBLIC IP>:~
```
- Extract tar file
```sh
tar xf <ANYFILE>.tar.gz
```
- Run app with PM2

```sh
pm2 start --name someApp app.js
```

- Start PM2 on instance restart

```sh
pm2 startup
#FOLLOW THE INSTRUCTIONS PROVIDED BY PM2
```

- Restart EC2 instance (DANGER)
```sh
sudo shutdown -r now
```
