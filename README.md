Epic Story/Vision - Create a website which is highly available, scalable, fault-tolerant using AWS
______________________________________________________________________________________
SPRINT 1
______________________________________________________________________________________
User Story 1: Setup development environment -  5 SP
Task 1: Setup Github a/c to have a centralized repository
Task 2: Setup Terraform OSS and enable tracing & capture the logs
Task 3: Setup AWS CLI v 2.0 + 
Task 4: Configure AWS sandbox a/c & verify IAM access
Task 5: Install Visual Studio Code & plugins like Intellisense to speed up the development  
Task 6: Setup Git to create a local repository
Task 7: Integrate GIT with GITHUB a/c along with security token

Responsibility : Team 1 = Collective Thinkers  
Status : Complete

Action Item: 
Pascal to check with Team1
User Story 2: Setup AWS infrastructure 
Task 1: Create a Virtual private cloud with CIDR 10.0.0.0/16 in the region us-west-2
Task 2: Add 4 subnets - (2 public and 2 private) - 1 public and 1 private in each availability zone
Task 3: Add NAT Gateway (*)
Task 4: Add Internet Gateway
Task 5: Add Routing tables with routes
	Public route table with IGW
	Private route table with NAT gateway(*)
Task 6: Associate routing tables with relevant subnets & verify NACL
Task 7: Add Network Access control lists
Task 7: Add security groups with rules SSH, http traffic originated from <specify CIDR>
Task 8: Add S3 bucket for storing wordpress package along with assets like Images, etc.,
Task 9: Retrieve the metadata and store it in local file 
Task 10: Add ReadMe.md

Status : Complete

Responsibility : Team 2

User Story 3: Setup a web server - 3 SP 
Task 1: Request latest AMI-Id for the respective region
Task 2: Create a web server using AWS EC2 service with the attributes like Instance Type, Keypair, Storage, etc., and use the script from User story 3 for the user data section. 

Responsibility : Team 1  = Collective Thinkers

Status : Complete
User Story 4: Application Load Balancer
Task 1: Create an Application Load Balancer
Task 2: Create a Listener for load balancer along with rule(s) - http (80)
Task 3: Create a Target Group
Task 4: Register Targets 
Task 5: Create a security group for Load Balancer

Responsibility : Team 3

Status : Complete
User Story 5: Auto Scaling Group
Task 1: Create a custom AMI with wordpress & configuration (optional)
Task 2: Create a Launch Template
use latest AMI
Task 3: Create an Auto Scaling Group
Specify capacity(min,max, desired)
Add Health checks
Task 4: Configure Auto Scaling Policy - Target Tracking Policy
Task 5: Associate the application load balancer with this ASG

Responsibility : Team 3

Status : Complete
User Story 6: Add Email notification
Task 1: Add cloudwatch metrics with CPU utilization & threshold configured. 
Task 2: Add a cloudwatch alarm based on above configuration
Task 3: Add SNS topic  
Task 4: Create subscription to the SNS topic with protocol - Email 
Task 5: Confirm the Email Subscription

Responsibility : Team 3

Status : Complete
User Story 7: Load Testing
Task 0: Verify the ALB url (DNS) via browser
Task 1: Run the stress tool to initiate the load on the EC2 server(s)
Task 2: Verify the Cloudwatch Alarm once it’s triggered as a result of breaching the threshold limit configured 
Task 3: Verify the Alarm status-In Alarm’ via email notification

Task 4: Verify whether it launches additional web servers as a part of Auto scaling group to handle the load.

Responsibility : Team 3
______________________________________________________________________________________
SPRINT 2
______________________________________________________________________________________
User Story 8: Create an RDS database to store wordpress data
Create a terraform script to perform the following activities: 

Create subnets and Subnet group
Security group to allow port 3306
RDS DB Instance with attributes like below
db engine - mysql 5.7
Instance Type : t2.micro (Burstable classes)
Free tier
Storage (default)
Credentials (admin/<password>)
Enhanced Monitoring- disabled
Auto minor upgrade- Enabled
Backup & Retention (disabled)
Password authentication
Multi-AZ not required

Responsibility : Team 3 
Status : Partially complete
User Story 9: Create a script for user-data - Setup Wordpress Server - 10 SP
Task 1: create a script to perform the following activities: 
Update the Installed packages to the latest version from the repository and install Apache web server, start & enable the service. 
Install MariaDB, start & enable the service
Install Wordpress, start & enable the service
Enable PHP 8.0 and update the system
Make a copy of wp-config-sample.php and rename it to wp-config.php. Configure this file with the latest RDS DB credentials 
Move the wordpress content to S3 bucket

Responsibility : Team 1  = Collective Thinkers
Status : Partially Complete
User Story 10 : Migrate the local wordpress DB to RDS
Task 1 : Migrate the local wordpress database to RDS using mysqldump utility and scripts 
Task 2 : Point the wordpress website to RDS database

Responsibility : Team 2 
Status : Not yet started
User Story 11 : Download the wordpress content from S3 bucket
Task 1: Download the wordpress content from S3 bucket and use it launching wordpress servers
Task 2: Synchronize the web content between local and S3 bucket

Responsibility : Team 3 
Status : Not yet started
User Story 12 : Infrastructure Monitoring & Logging
Install and configure the unified CloudWatch agent to push metrics and logs from wordpress servers to CloudWatch service

Responsibility : Team 2 
Status : Not yet started
User Story 13 : Build the architecture diagram using tools like lucidchart, draw.io

Responsibility : <>  
Status : Not yet started

****** OLD VERSION ******
C1_Challenge - Friday 14.July.2023

 Create terraform project to setup the infrastructure in AWS environment using sandbox environment. (Note : 20 USD limit)
   Components :
   1. VPC
   2. Four subnets - (2 public and 2 private)
      1 public and 1 private in each availability zone
   3. Internet Gateway
   4. Routing tables - Public & Private. Add routes
   5. Associate Routing tables with relevant subnets
   6. Setup an EC2 instance with wordpress in public subnet - AZ1 using terraform script only. (Not via AWS management console or SSH)
      -> PHP
      -> Apache web server
      -> Mysql or mariaDB
      -> wordpress
   7. Security group with ingress - http only. No SSH or https
   8. By EOB, please check-in the code to github repository for review
   9. Capture the screenshots - Wordpress blog page
________________________________________________________________________________________

C2_Challenge - Friday 21.July.2023

***Add following new components to project..architecture***
1) Application Load balancer 
2) Auto Scaling group
   
Sample code provided here for reference:

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb

3)Create a document with Infrastructure/Architecture diagram along with screenshots
________________________________________________________________________________________




