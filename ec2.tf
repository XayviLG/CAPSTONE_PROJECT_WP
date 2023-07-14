resource "aws_instance" "deham6demos"{
    ami = "ami-0ae49954dfb447966"
    instance_type = "t2.micro"
    key_name = "vockey"
    vpc_security_group_ids = [aws_security_group.devVPC_sg_allow_ssh_http.id]
    subnet_id = aws_subnet.devVPC_public_subnet1.id
    user_data = filebase64("${path.module}/userdata.sh")
    tags = {
        Name = "deham6demos"
    }
    provisioner "local-exec"{
    command = "echo Instance Type=${self.instance_type},Instance ID=${self.id},Public DNS=${self.public_dns},AMI ID=${self.ami} >> allinstancedetails"
  }
}
