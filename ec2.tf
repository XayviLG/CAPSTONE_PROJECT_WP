resource "aws_instance" "wordpress"{
    ami = "ami-0507f77897697c4ba"
    instance_type = "t2.micro"
    key_name = "cool"
    vpc_security_group_ids = [aws_security_group.devVPC_sg_allow_http.id]
    subnet_id = aws_subnet.devVPC_public_subneta.id
    user_data = "${file("userdata.sh")}"
    tags = {
        Name = "wordpress"
    }
    provisioner "local-exec"{
    command = "echo Instance Type=${self.instance_type},Instance ID=${self.id},Public DNS=${self.public_dns},AMI ID=${self.ami} >> allinstancedetails"
  }
}
#