In this case I will be using DigitalOcean to host a CentOS server.

1. Spin up server
    1. In the navigation bar go to Creat > **Droplet**
    2. Choose an image > Distribution > **CentOS 8.2 x64**
    3. Choose a plan
    4. Add block storage **(Skip)**
    5. Choose a data close to you
    6. Add SSH Key
        1. Generate public and private keys in the local machine
            ```sh
            ssh-keygen -t rsa -b 4096
            ```
            Use default directory and filename. Password is optional.
        2. Transfer public key to the server
            ```sh
            ssh-copy-id username@[insert-ip]
            ```
            DigitalOcean gives you the option to enter the content of the public key in the web user interface. If you do this, skip this step.
        3. Disable password authentication in the server
            ```sh
            nano /etc/ssh/sshd_config
            ```
            Set the following line to `no`:
            ```sh
            PasswordAuthentication no
            ```

2. Setup DNS with Namecheap

    1. Log into NameCheap.com
    2. Buy a domain and go to your NameCheap dashboard > Domain List > select a domain name > **manage**
    3. In the top bar select **Advanced DNS** > Under **host records** you should see 2 entries with “@” and “www”
    4. Switch to DigitalOcean
    7. Copy the **Public IP IPv4** from the droplet's description
    8. Go back to NameCheap and match the following table:
   
    | Type         | Host | Value                            |
    |--------------|------|----------------------------------|
    | A Record     |   @  | IPv4 Public IP [123.123.123.123] |
    | A Record     |  www | IPv4 Public IP [123.123.123.123] |
