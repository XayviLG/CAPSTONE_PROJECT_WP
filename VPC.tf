# Query all available Availability Zone; we will use specific availability zone using index - The Availability Zones data source
# provides access to the list of AWS availabililty zones which can be accessed by an AWS account specific to region configured in the provider
data "aws_availability_zones" "cpstn_vpc_azs"{}

#Create a Virtual private cloud with CIDR 10.0.0.0/16 in the region us-west-2

resource "aws_vpc" "cpstn_vpc"{
    cidr_block             = var.cidr_block_cpstn_vpc
    enable_dns_hostnames   =true
    enable_dns_support     = true
    tags                   = {
        Name               = "cpstn_VPC"
    }
    provisioner "local-exec"{
    command                = "echo vpc ID=${self.id} >> metadata"
  }
}

# Public subnet 1 

resource "aws_subnet" "cpstn_publicsubnet_1"{
    cidr_block             = var.cidr_block_cpstn_publicsubnet_1 #256 IPs
    vpc_id                 = aws_vpc.cpstn_vpc.id
    map_public_ip_on_launch= true
    availability_zone      = data.aws_availability_zones.cpstn_vpc_azs.names[1]
    tags                   = {
        Name               = "capstone_publicSubnet_1"
    }
    provisioner "local-exec"{
    command                = "echo Public Subnet 1 = ${self.id} >> metadata"
  }
}

# Private Subnet 1

resource "aws_subnet" "cpstn_privatesubnet_1"{
    cidr_block             = var.cidr_block_cpstn_privatesubnet_1
    vpc_id                 = aws_vpc.cpstn_vpc.id
    map_public_ip_on_launch= false
    availability_zone      = data.aws_availability_zones.cpstn_vpc_azs.names[1]
    tags                   = {
        Name               = "capstone_privateSubnet_1"
    }
    provisioner "local-exec"{
    command                = "echo Private Subnet 1 = ${self.id} >> metadata"
  }
}

# Public subnet 2

resource "aws_subnet" "cpstn_publicsubnet_2"{
    cidr_block             = var.cidr_block_cpstn_publicsubnet_2 #256 IPs
    vpc_id                 = aws_vpc.cpstn_vpc.id
    map_public_ip_on_launch= true
    availability_zone      = data.aws_availability_zones.cpstn_vpc_azs.names[2]
    tags                   = {
        Name               = "capstone_publicSubnet_2"
    }
    provisioner "local-exec"{
    command                = "echo Public Subnet 2 = ${self.id} >> metadata"
  }
}

# Private Subnet 2

resource "aws_subnet" "cpstn_privatesubnet_2"{
    cidr_block             = var.cidr_block_cpstn_privatesubnet_2
    vpc_id                 = aws_vpc.cpstn_vpc.id
    map_public_ip_on_launch= false
    availability_zone      = data.aws_availability_zones.cpstn_vpc_azs.names[2]
    tags                   = {
        Name               = "capstone_privateSubnet_2"
    }
    provisioner "local-exec"{
    command                = "echo Private Subnet 2 = ${self.id} >> metadata"
  }
}

# To access EC2 instance inside a Virtual Private Cloud (VPC) we need an Internet Gateway
# and a routing table Connecting the subnet to the Internet Gateway
# Creating Internet Gateway
# Provides a resource to create a VPC Internet Gateway
resource "aws_internet_gateway" "cpstn_IGW"{
    vpc_id                 = aws_vpc.cpstn_vpc.id
    tags                   = {
        Name               = "cpstn_vpc_igw"
    }
    provisioner "local-exec"{
    command                = "echo Internet Gateway = ${self.id} >> metadata"
  }
}
# Routing tables
# Provides a resource to create a VPC public routing table with IGW
resource "aws_route_table" "cpstn_publicRouteTable1"{
    vpc_id                 = aws_vpc.cpstn_vpc.id
    route{
        cidr_block         = var.cidr_blocks
        gateway_id         = aws_internet_gateway.cpstn_IGW.id
    }
    tags                   = {
        Name               = "cap_publicRoute"
    }
}
# Provides a resource to create an association between a Public Route Table and a Public Subnet 1
resource "aws_route_table_association" "cpstn_publicSubnetAssociation1" {
    route_table_id         = aws_route_table.cpstn_publicRouteTable1.id
    subnet_id              = aws_subnet.cpstn_publicsubnet_1.id
    depends_on             = [aws_route_table.cpstn_publicRouteTable1, aws_subnet.cpstn_publicsubnet_1]
}
# Provides a resource to create an association between a Public Route Table and a Public Subnet 2
resource "aws_route_table_association" "cpstn_publicSubnetAssociation2" {
    route_table_id         = aws_route_table.cpstn_publicRouteTable1.id
    subnet_id              = aws_subnet.cpstn_publicsubnet_2.id
    depends_on             = [aws_route_table.cpstn_publicRouteTable1, aws_subnet.cpstn_publicsubnet_2]
}
/**# Adding NAT Gatway
# Create Elastic IP. The advantage of associating the Elastic IP address with the network interface instead of directly with the instance is that you can move all the attributes of the network interface from one instance to another in a single step.

resource "aws_eip" "cpstn_eip" {
    domain                 = "vpc"
#   vpc                    = true
    tags                   = {
    Name                   = "cap_elastic_ip"
  }
}
# NAT Gateway in public subnet 1 and assigned the above created Elastic IP to it

resource "aws_nat_gateway" "cpstn_natgateway" {
    allocation_id          = "${aws_eip.cpstn_eip.id}"
    subnet_id              = "${aws_subnet.cpstn_publicsubnet_2.id}"
    tags                   = {
    Name                   = "cpstn_natgateway"
  }
}**/

#Create a Route Table in order to connect our private subnet to the NAT Gateway

resource "aws_route_table" "cpstn_privateRouteTable1"{
    vpc_id                 = "${aws_vpc.cpstn_vpc.id}"
#   route{
#   cidr_block             = "0.0.0.0/0"
#   gateway_id             = "${aws_nat_gateway.cpstn_natgateway.id}"
#}
    tags                   = {
        Name               = "cap_privateRoute"
    }
}
# Associate this route table to private subnet
resource "aws_route_table_association" "cpstn_privateSubnetAssociation1" {
    route_table_id         = aws_route_table.cpstn_privateRouteTable1.id
    subnet_id              = aws_subnet.cpstn_privatesubnet_1.id
    depends_on             = [aws_route_table.cpstn_privateRouteTable1, aws_subnet.cpstn_privatesubnet_1]
}
resource "aws_route_table_association" "cpstn_privateSubnetAssociation2" {
    route_table_id         = aws_route_table.cpstn_privateRouteTable1.id
    subnet_id              = aws_subnet.cpstn_privatesubnet_2.id
    depends_on             = [aws_route_table.cpstn_privateRouteTable1, aws_subnet.cpstn_privatesubnet_2]
}
