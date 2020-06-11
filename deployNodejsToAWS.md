All the omitted options are either optional or correct by default.
1. Open the AWS management console.
2. Go to Elastic Beanstalk > Environments and click on create a new application
3. Select environment tier

    - Select: Web Server Environment
4. Create a web server environment

    - Application information > Application name: [Pick a name]
    - Environment information > Environment name: [Pick a name]
    - Platform > Managed Platform
    - Platform > Plaform: Nodejs
    - Platform > Plaform: Node.js 
    - Platform > Plaform branch: Node.js 12 running on 64bit Amazon Linux 2
    - Platform > Plaform version: 5.0.2 (recommended)
    - Application Code > Sample application (This will get replaced once the code is pushed into the instance with AWS CodePipeline)

5. Configure more options

    - Be mindful. I recommend just to add environment variables and leave the rest unchanged as it may result and additional charges.
    - Software > Environment Variables (Enter any environment variables. Entering env vars this way it's safer because they're isolated from the source code. Remember that only the "SECRETS" need to be added this way. Any other evironment variables can be harcoded.) 

CODE PIPELINE

1. Go to Developer Tools > Code Pipeline > Pipelines
2. Click on Create a pipeline
3. Choose Pipeline settings > Pipeline Settings

    - Pipeline name: [Choose a name]
    - Service Role: New Service Role

4. Source > Source Provide: GitHub

    - Connect to Github, select Repository and Branch

5. Change Detections options > GitHub Webhooks (recommended)
6. Build - optional > Skip build stage (Go ahead and add a build stage if you know what you're doing)
7. Deploy > Deploy provider: AWS Elastic Beanstalk
    - Application name: The EBS app that you just created.
    - Environment name: The env of the EBS app

IF USING EXTERNAL DATABASE

MONGO DB

    - Go to EC2 Dashboard
    - Select the EC2 instance created by EBS and copy the its Public IP.
    - Actions > Networking > Manage IP addresses
    - Copy Public IP
    - Go to Mongo DB dashboard > Network Access > IP Whitelist
    - Click on ADD IP ADDRESS
    - Whitelist Entry: [Public IP]/32 (The /32 means only one IP, not a range)
    - Don't make this a temporary entry