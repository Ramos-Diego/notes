In this case I will be using DigitalOcean to host the Ubuntu server.

1. Spin up server
    1. In the navigation bar go to Creat > **Droplet**
    2. Choose an image > Distribution > **Ubuntu 20.04 (LTS) x64**
    3. Choose a plan
    4. Add block storage (Skip)
    5. Choose a data close to you
    6. Add SSH Key
        1. Generate public and private keys in the local machine
            ```sh
            ssh-keygen -t rsa -b 4096
            ```
            Use default directory and filename. Only add a password to max out the security.
        2. Transfer public key to the server
            ```sh
            ssh-copy-id username@[insert-ip]
            ```
        3. Disable password authentication
            ```sh
            nano /etc/ssh/sshd_config
            ```
            Set the following line to `no`:
            ```sh
            PasswordAuthentication no
            ```

    Get your public IP: https://api.ipify.org/

5. Setup DNS with Namecheap

    1. Log into NameCheap.com
    2. Buy a domain and go to your NameCheap dashboard > Domain List > select a domain name > **manage**
    3. In the top bar select **Advanced DNS** > Under **host records** you should see 2 entries with “@” and “www”
    4. Switch to AWS management console 
    5. In the navigation bar go to Services > **EC2**
    6. In the left bar go to Instances > **Intances**
    7. Copy the **Public DNS (IPv4)** and **IPv4 Public IP** from the instance's description
    8. Go back to NameCheap and match the following table:
   
    | Type         | Host | Value                                       |
    |--------------|------|---------------------------------------------|
    | A Record     |   @  | IPv4 Public IP [123.123.123.123]            |
    | CNAME Record |  www | Public DNS (IPv4) [some_link.amazonaws.com] |
