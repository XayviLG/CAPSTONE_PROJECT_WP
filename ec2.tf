# Select newest AMI-id

data "aws_ami" "my_latest_linux_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"] # Amazon
}

###Create EC2
resource "aws_instance" "my_Bastion"{
    ami                    = data.aws_ami.my_latest_linux_ami.id
   #ami                    = "ami-08541bb85074a743a"
    instance_type          = "t2.micro"
    key_name               = "vockey"
    vpc_security_group_ids = [aws_security_group.my_sg_bastion.id]
    subnet_id              = aws_subnet.my_publicSubnet_1.id
    tags = {
        Name = "my_Bastion"
        }
    
    provisioner "local-exec"{
        command = "echo Instance Type=${self.instance_type},Instance ID=${self.id},Public DNS=${self.public_dns},AMI ID=${self.ami} >> allinstancedetails"
    }
}