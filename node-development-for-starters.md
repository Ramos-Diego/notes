# Setup a dev environment for Node.js in Windows

## Install Windows Subsystem for Linux [(WSL 2)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)

## Update your Linux distribution (Ubuntu)

```
apt update && \
apt upgrade -y && \
reboot
```

## Install Node.js 14

```sh
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
apt install -y nodejs
```

I chose Node 14, but you can choose any version of Node.js from [here](https://github.com/nodesource/distributions/blob/master/README.md).

Install **Development tools** (for Node.js).
```sh
apt install -y gcc g++ make
```

This step should also install npm.

## Intall Yarn, a much faster and better alternative to the Node Package Manager (NPM).

```sh
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
apt update && apt install -y yarn
```

[Official yarn debian guide](https://classic.yarnpkg.com/en/docs/install/#debian-stable).

## Install **Git**. It is needed to use GitHub.
```sh
apt install -y git
```

## Find your home directory in WSL

1. Press Windows Key + E 
2. Enter `\\wsl$\` in the address bar
3. Navigate until you reach a directory similiar to this

```
\\wsl$\Ubuntu-20.04\home\jeff\
```

Use this path in VSCode. Otherwise, you may have issues running some commands from VSCode terminal.

## Install [VSCode](https://code.visualstudio.com/), the only text editor you will need.
