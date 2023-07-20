Challenge - Friday 14.July.2023
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
   9. Capture the screenshots - Wordpress blog page and share it with us
