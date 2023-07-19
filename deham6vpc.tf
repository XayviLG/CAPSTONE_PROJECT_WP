# Query all available Availability Zone; we will use specific availability zone using index - The Availability Zones data source
# provides access to the list of AWS availabililty zones which can be accessed by an AWS account specific to region configured in the provider.
data "aws_availability_zones" "devVPC_available"{}
resource "aws_vpc" "devVPC"{
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames=true
    enable_dns_support = true
    tags = {
        Name = "dev_terraform_vpc"
    }
}
# Public subnet public CIDR block available in vars.tf and provisionersVPC
resource "aws_subnet" "devVPC_public_subneta"{
    cidr_block = "10.0.0.0/24"
    vpc_id = aws_vpc.devVPC.id
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.devVPC_available.names[1]
    tags = {
        Name = "dev_terraform_vpc_public_subneta"
    }
}
resource "aws_subnet" "private_subneta"{
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.devVPC.id
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.devVPC_available.names[1]
    tags = {
        Name = "dev_terraform_vpc_private_subneta"
    }
}
resource "aws_subnet" "devVPC_public_subnetb"{
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.devVPC.id
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.devVPC_available.names[2]
    tags = {
        Name = "dev_terraform_vpc_public_subnetb"
    }
}
resource "aws_subnet" "private_subnetb"{
    cidr_block = "10.0.3.0/24"
    vpc_id = aws_vpc.devVPC.id
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.devVPC_available.names[2]
    tags = {
        Name = "dev_terraform_vpc_private_subnetb"
    }
}

# To access EC2 instance inside a Virtual Private Cloud (VPC) we need an Internet Gateway
# and a routing table Connecting the subnet to the Internet Gateway
# Creating Internet Gateway
# Provides a resource to create a VPC Internet Gateway
resource "aws_internet_gateway" "devVPC_IGW"{
    vpc_id = aws_vpc.devVPC.id
    tags = {
        Name = "dev_terraform_vpc_igw"
    }
}
# Provides a resource to create a VPC routing table
resource "aws_route_table" "devVPC_public_routea"{
    vpc_id = aws_vpc.devVPC.id
    route{
        cidr_block = var.cidr_blocks
        gateway_id = aws_internet_gateway.devVPC_IGW.id
    }
    tags = {
        Name = "dev_terraform_vpc_public_routea"
    }
}
# Provides a resource to create an association between a Public Route Table and a Public Subnet A
resource "aws_route_table_association" "public_subnet_associationa" {
    route_table_id = aws_route_table.devVPC_public_routea.id
    subnet_id = aws_subnet.devVPC_public_subneta.id
    depends_on = [aws_route_table.devVPC_public_routea, aws_subnet.devVPC_public_subneta]
}
# Provides a resource to create an association between a Public Route Table and a Public Subnet A
resource "aws_route_table_association" "public_subnet_associationb" {
    route_table_id = aws_route_table.devVPC_public_routea.id
    subnet_id = aws_subnet.devVPC_public_subnetb.id
    depends_on = [aws_route_table.devVPC_public_routea, aws_subnet.devVPC_public_subnetb]
}
