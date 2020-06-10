# AWS Notes

AWS [Free tier](https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc) relevant to Node.js apps

- Volumes

Amazon Elastic Block Storage (30 GiB) any combination of General Purpose (SSD) or Magnetic. Persistent, durable, low-latency block-level storage volumes for EC2 instances. 2,000,000 I/Os (with EBS Magnetic) 1 GB of snapshot storage. This is the default selection for EC2 instances.

- Amazon S3

As part of the AWS Free Usage Tier, you can get started with Amazon S3 for free. Upon sign-up, new AWS customers receive 5GB of Amazon S3 storage in the S3 Standard storage class; 20,000 GET Requests; 2,000 PUT, COPY, POST, or LIST Requests; and 15GB of Data Transfer Out each month for one year. This is where Elastic Beanstalk stores your source code.

- EC2 

750 hours per month of Linux, RHEL, or SLES t2.micro or t3.micro instance dependent on region. This is the "computer/server" that Elastic Beanstalk uses to run your web app.

- Elastic Beanstalk (EBS)

A wizard to host a web application. Such wizard doesn't cost any money because it only instantiates what's needed for the application (EC2, S3, Load Balancer, etc). It doesn't run the application. It is not necessary to setup a web application, but it greatly simplifies everything.

Source code can be directly submitted through EBS as a zip file containing the files, not a zipped folder containing the files.

On the configuration page for EBS you can choose the EC2 instance, S3 buckets, and more.

The EBS environment is the actual application to be deployed.

> With Elastic Beanstalk, you can quickly deploy and manage applications in the AWS Cloud without having to learn about the infrastructure that runs those applications. Elastic Beanstalk reduces management complexity without restricting choice or control. You simply upload your application, and Elastic Beanstalk automatically handles the details of capacity provisioning, load balancing, scaling, and application health monitoring.

Elastic Beanstalk is intended for a single optimized and scalable app. If attempting to run multiple applications in a single EC2 instance, Elastic Beanstalk is not appropiate.[[1]](https://stackoverflow.com/questions/12713834/running-multiple-environments-on-one-aws-ec2-instance-elastic-beanstalk)

- IAM 

Make sure to have all of the IAM security checks green.

Create a user for yourself and any other person. You don't want to login as root to do everyday work. 

Create an admin group using the AdministratorAccess policy provided by AWS and add your own IAM account to that group. 

Enable MFA for both, the root account and the admin IAM account. 

- EC2

Elastic Compute Cloud (EC2), enables for "computer" instances to be initiated with various CPU and RAM count. This is the "computer" AWS will lend you to do anything you want.

- Codepipeline

- Codebuild 

4. Route 53 ([custom URL](https://stackoverflow.com/questions/12280220/custom-url-at-aws-elastic-beanstalk))

- [SSH into an EC2 instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)

Go to the EC2 dashboard and create a new Key Pair.
Download as a .pem file and secure that file. Do not delete.
To [SSH into EC2 instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html), go to file in command line and run:

``` bash
chmod 400 /path/my-key-pair.pem
ssh -i /path/my-key-pair.pem my-instance-user-name@my-instance-public-dns-name
```

- EC2 Security Groups

The Inboud should be as restritive as possible. Only allow certain IPs to SSH into the instance. Use a [CIDR](http://jodies.de/ipcalc) calculator to determine your range of IPs or set only your IP. Please, note that for normal home networks IPs are not static by default, so setting just one IP instead of a range of IPs may cause you to lose access to the instance.

- VPC

Amazon Virtual Private Cloud (Amazon VPC) lets you provision a logically isolated section of the AWS Cloud where you can launch AWS resources in a virtual network that you define. You have complete control over your virtual networking environment, including selection of your own IP address range, creation of subnets, and configuration of route tables and network gateways. You can use both IPv4 and IPv6 in your VPC for secure and easy access to resources and applications.

This is more of a system administrator kind of job. It can become very conversome to deal with.

Topics to know: IPv4, IPv6, subnets, [CIDR](http://jodies.de/ipcalc), subnet masking, NAT Gateway, Default Gateway.

- Lambda functions/serverless

