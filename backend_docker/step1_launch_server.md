Login to AWS

1. In the navigation bar go to Services > **EC2**
2. In the left bar go to Instances > Intances > **Launch instance**
    
    1. Choose AMI > Select **Amazon Linux 2 AMI (HVM), SSD Volume Type** (This is free tier eligible)
    2. Choose an instance type > Type > **t2.micro** (Free tier eligible)
    Note: The name of the instance can be different based on region. Simply choose **(Free tier eligible)**
    3. Configure Instance Details > **Good as defualt**
    4. Add Storage > **Good as defualt**
    5. Add Tags > **Good as defualt**
    6. Configure Security Group > Add the following rules:
    
    Get your public IP: https://api.ipify.org/
    ```
    | Type  | Protocol | Port range | Source (CIDR blocks) | Description   |
    |-------|----------|------------|----------------------|---------------|
    | HTTP  | TCP      | 80         | 0.0.0.0/0            | HTTP          |
    | SSH   | TCP      | 22         | <your-public-ip>/24  | ADMIN SSH     |
    | HTTPS | TCP      | 443        | 0.0.0.0/0            | HTTPS         |
    ```

    7. Review all the settings and launch the EC2 instance

3. Create a new key pair (DANGER, THIS IS A VERY IMPORTANT STEP)

    1. Select: **Create a new key pair**
    2. Enter a key pair name: **myEC2key**
    3. **Download the key pair** and store it somewhere safe in your local machine. You may also back it up somewhere. 

4. Set Elastic IP

    1. In the navigation bar go to Services > **EC2**
    2. In the left bar go to Network and Security > **Elastic IPs**
    3. Select **Allocate Elastic IP Address**
    4. Under Public IPv4 address pool > **Amazon's pool of IPv4 addresses**
    5. Select the Elastic IP > Actions > **Associate Elastic IP Address**
    6. Resource type: **Instance** <br>
        Instance: **Select your instance** <br>
        Private IP address: **Select your instance's private IP** <br>
        Reassociation: **Uncheked**

5. Setup DNS with Namecheap

    1. Log into NameCheap.com
    2. Buy a domain and go to your NameCheap dashboard > Domain List > select a domain name > **manage**
    3. In the top bar select **Advanced DNS** > Under **host records** you should see 2 entries with “@” and “www”
    4. Switch to AWS management console 
    5. In the navigation bar go to Services > **EC2**
    6. In the left bar go to Instances > **Intances**
    7. Copy the **Public DNS (IPv4)** and **IPv4 Public IP** from the instance's description
    8. Go back to NameCheap and match the following table:
    ```
    | Type         | Host | Value                                       |
    |--------------|------|---------------------------------------------|
    | A Record     |   @  | IPv4 Public IP [123.123.123.123]            |
    | CNAME Record |  www | Public DNS (IPv4) [some_link.amazonaws.com] |
    ```