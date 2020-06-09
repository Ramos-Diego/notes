# AWS Notes



- Elastic Beanstalk (EBS)

A wizard to host a web application. Such wizard doesn't cost any money because it only instatiates what's needed for the application (EC2, S3, Load Balancer, etc). It doesn't run the application. It is not necessary to setup a web application, but it greatly simplifies the process.

Source code can be directly submitted through EBS as a zip containing the files, not a zip a folder containing the files.

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
