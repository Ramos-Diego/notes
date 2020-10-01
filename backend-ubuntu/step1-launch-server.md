In this tutorial I will go in depth on how to create a fully fledged CI/CD setup for a Node app. I mainly use this setup to create APIs. There are easier ways to do this with services like Elastic Beanstalk from AWS, but here you will learn how it all works behind the scenes.

By the end of this tutorial you will have an API in your domain `https://api.example.com`. Nginx configured as a reverse proxy and HTTPS only server for a Node application running on Ubuntu 20.08. The node app will be managed by PM2 to enable 0-downtime deployments and persist the app after a reboot. And finally a Jenkins server which will enable a complete CI/CD experience where you commit to GitHub and within a minute your update will be deployed. 

You can extend this knowledge to serve Single-page apps with React and its own API, or server-side rendered websites with Express and EJS, and much more.

I will assume that you know the basics of the Linux command line, NGINX and Node.js.

# Spin up a server

I will be using DigitalOcean to host the Ubuntu server.

## Create Droplet 

1. In the navigation bar go to Create > **Droplet**

2. Choose an image > Distribution > **Ubuntu 20.04 (LTS) x64**

3. Choose a plan

4. Add block storage **(Skip)**

5. Choose a data center close to you

6. Add SSH Key

    1. Generate public and private keys in your local machine
        
        ```sh
        ssh-keygen -t rsa -b 4096
        ```
        
        Use default directory and filename. Password is optional.
    
    2. Transfer your public key to the server
        
        ```sh
        ssh-copy-id username@[insert-ip]
        ```
        
        DigitalOcean gives you the option to enter the content of the public key in the web user interface. Skip this step if you did this.
    
    3. Disable password authentication in the server
        
        ```sh
        nano /etc/ssh/sshd_config
        ```

        Set the following line to `no`:
        ```sh
        PasswordAuthentication no
        ```

        Password authentication is not recommended for your server's security. You may leave it on if wish.

## Setup DNS with Namecheap

1. Log into NameCheap.com

2. Buy a domain and go to your NameCheap dashboard > Domain List > select a domain name > **manage**

3. In the top bar select **Advanced DNS** > Under **host records** you should see 2 entries with “@” and “www”

4. Switch to DigitalOcean

5. Copy the **Public IP IPv4** from the droplet's description

6. Go back to NameCheap and enter your **Public IP IPv4**:

<center>

| Type     | Host | Value           |
|----------|------|-----------------|
| A Record |   @  | 123.123.123.123 |
| A Record |  www | 123.123.123.123 |

</center>