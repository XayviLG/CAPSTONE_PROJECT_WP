# Select newest AMI-id

data "aws_ami" "cpstn_latest_linux_ami" {
  most_recent              = true
  owners                   = ["amazon"] # Amazon

  filter {
    name                   = "name"
    values                 = ["al2023-ami-2023*x86_64"]
  }
}

###Create EC2
resource "aws_instance" "cpstn_Bastion"{
    ami                    = data.aws_ami.cpstn_latest_linux_ami.id
   #ami                    = "ami-08541bb85074a743a"
    instance_type          = "t2.micro"
    key_name               = "vockey"
    vpc_security_group_ids = [aws_security_group.cpstn_sg_bastion.id]
    subnet_id              = aws_subnet.cpstn_publicsubnet_1.id
    tags = {
        Name               = "cpstn_Bastion"
        }
    
    provisioner "local-exec"{
        command            = "echo Instance Type=${self.instance_type},Instance ID=${self.id},Public DNS=${self.public_dns},AMI ID=${self.ami} >> metadata"
    }
}