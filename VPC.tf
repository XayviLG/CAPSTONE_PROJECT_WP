# Query all available Availability Zone; we will use specific availability zone using index - The Availability Zones data source
# provides access to the list of AWS availabililty zones which can be accessed by an AWS account specific to region configured in the provider
data "aws_availability_zones" "myVPC_azs"{}

#Create a Virtual private cloud with CIDR 10.0.0.0/16 in the region us-west-2

resource "aws_vpc" "myVPC"{
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames=true
    enable_dns_support = true
    tags = {
        Name = "cap_vpc"
    }
}

# Public subnet 1 

resource "aws_subnet" "my_publicSubnet_1"{
    cidr_block = "10.0.1.0/24" #256 IPs
    vpc_id = aws_vpc.myVPC.id
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.myVPC_azs.names[1]
    tags = {
        Name = "capstone_publicSubnet_1"
    }
}

# Private Subnet 1

resource "aws_subnet" "my_privateSubnet_1"{
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.myVPC.id
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.myVPC_azs.names[1]
    tags = {
        Name = "capstone_privateSubnet_1"
    }
}

# Public subnet 2

resource "aws_subnet" "my_publicSubnet_2"{
    cidr_block = "10.0.3.0/24" #256 IPs
    vpc_id = aws_vpc.myVPC.id
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.myVPC_azs.names[2]
    tags = {
        Name = "capstone_publicSubnet_2"
    }
}

# Private Subnet 2

resource "aws_subnet" "my_privateSubnet_2"{
    cidr_block = "10.0.4.0/24"
    vpc_id = aws_vpc.myVPC.id
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.myVPC_azs.names[2]
    tags = {
        Name = "capstone_privateSubnet_2"
    }
}

# To access EC2 instance inside a Virtual Private Cloud (VPC) we need an Internet Gateway
# and a routing table Connecting the subnet to the Internet Gateway
# Creating Internet Gateway
# Provides a resource to create a VPC Internet Gateway
resource "aws_internet_gateway" "my_IGW"{
    vpc_id = aws_vpc.myVPC.id
    tags = {
        Name = "cap_vpc_igw"
    }
}
# Routing tables
# Provides a resource to create a VPC public routing table with IGW
resource "aws_route_table" "my_publicRouteTable"{
    vpc_id = aws_vpc.myVPC.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_IGW.id
    }
    tags = {
        Name = "cap_publicRoute"
    }
}
# Provides a resource to create an association between a Public Route Table and a Public Subnet 1
resource "aws_route_table_association" "my_publicSubnetAssociation1" {
    route_table_id = aws_route_table.my_publicRouteTable.id
    subnet_id = aws_subnet.my_publicSubnet_1.id
    depends_on = [aws_route_table.my_publicRouteTable, aws_subnet.my_publicSubnet_1]
}
# Provides a resource to create an association between a Public Route Table and a Public Subnet 2
resource "aws_route_table_association" "my_publicSubnetAssociation2" {
    route_table_id = aws_route_table.my_publicRouteTable.id
    subnet_id = aws_subnet.my_publicSubnet_2.id
    depends_on = [aws_route_table.my_publicRouteTable, aws_subnet.my_publicSubnet_2]
}
# Adding NAT Gatway
# Create Elastic IP. The advantage of associating the Elastic IP address with the network interface instead of directly with the instance is that you can move all the attributes of the network interface from one instance to another in a single step.

resource "aws_eip" "my_eip" {
    domain = "vpc"
#   vpc = true
    tags = {
    Name = "cap_elastic_ip"
  }
}
# NAT Gateway in public subnet 1 and assigned the above created Elastic IP to it

resource "aws_nat_gateway" "my_NatGateway" {
  allocation_id = "${aws_eip.my_eip.id}"
  subnet_id     = "${aws_subnet.my_publicSubnet_1.id}"


  tags = {
    Name = "my_NatGateway"
  }
}

#Create a Route Table in order to connect our private subnet to the NAT Gateway

resource "aws_route_table" "my_privateRouteTable"{
    vpc_id = "${aws_vpc.myVPC.id}"
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.my_NatGateway.id}"
    }
    tags = {
        Name = "cap_privateRoute"
    }
}
# Associate this route table to private subnet
resource "aws_route_table_association" "my_privateSubnetAssociation1" {
    route_table_id = aws_route_table.my_privateRouteTable.id
    subnet_id = aws_subnet.my_privateSubnet_1.id
    depends_on = [aws_route_table.my_privateRouteTable, aws_subnet.my_privateSubnet_1]
}
resource "aws_route_table_association" "my_privateSubnetAssociation2" {
    route_table_id = aws_route_table.my_privateRouteTable.id
    subnet_id = aws_subnet.my_privateSubnet_2.id
    depends_on = [aws_route_table.my_privateRouteTable, aws_subnet.my_privateSubnet_2]
}
