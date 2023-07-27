# Security Group for Bastion
resource "aws_security_group" "my_sg_bastion"{
    vpc_id = aws_vpc.myVPC.id
    name = "my_securityGrouplatest"
    tags = {
        Name = "cap-sg-bastion"
    }     
}

# Rules bastion - Ingress Security Port 22 (Inbound)
resource "aws_security_group_rule" "my_ingress_ssh"{
    from_port = 22
    protocol = "tcp"
    security_group_id = aws_security_group.my_sg_bastion.id
    to_port= 22
    type = "ingress"
    cidr_blocks = ["0.0.0.0/0"] # <Specify the CIDR> instead of allowing it to public
}

# Rules bastion - Allow Access All (Outbound)
resource "aws_security_group_rule" "my_outbound_all"{
    from_port = 22
    protocol = "tcp"
    security_group_id = aws_security_group.my_sg_bastion.id
    to_port= 22
    type = "egress"
    cidr_blocks = ["0.0.0.0/0"]
}
# Security Group for Application Load balancer and rules
resource "aws_security_group" "my-alb-sg"{
        vpc_id                      = aws_vpc.myVPC.id
        name                        = "alb-sg"
        tags = {
            Name = "cap-alb-sg"
        }
    }
    resource "aws_security_group_rule" "alb-sg-http-in"{
        from_port                   = 80
        protocol                    = "tcp"
        security_group_id           = aws_security_group.my-alb-sg.id
        to_port                     = 80
        type                        = "ingress"
        cidr_blocks                 = ["0.0.0.0/0"]
    }
    resource "aws_security_group_rule" "alb-sg-https-in"{
        from_port                   = 443
        protocol                    = "tcp"
        security_group_id           = aws_security_group.my-alb-sg.id
        to_port                     = 443
        type                        = "ingress"
        cidr_blocks                 = ["0.0.0.0/0"]
    }
    resource "aws_security_group_rule" "alb-sg-all-out"{
        from_port                   = 0
        protocol                    = "all"
        security_group_id           = aws_security_group.my-alb-sg.id
        to_port                     = 65535
        type                        = "egress"
        cidr_blocks                 = ["0.0.0.0/0"]
    }
#Security Group for Autoscaling and rules
resource "aws_security_group" "my-autoscaling-sg"{
        vpc_id                      = aws_vpc.myVPC.id
        name                        = "autoscaling-sg"
        tags = {
            Name = "cap-autoscaling-sg"
        }
    }
    resource "aws_security_group_rule" "autoscaling-sg-ssh-in"{
        from_port                   = 22
        protocol                    = "tcp"
        security_group_id           = aws_security_group.my-autoscaling-sg.id
        to_port                     = 22
        type                        = "ingress"
        cidr_blocks                 = ["0.0.0.0/0"]
    }
    resource "aws_security_group_rule" "autoscaling-sg-http-in"{
        from_port                   = 80
        protocol                    = "tcp"
        security_group_id           = aws_security_group.my-autoscaling-sg.id
        to_port                     = 80
        type                        = "ingress"
        cidr_blocks                 = ["0.0.0.0/0"]
    }
    resource "aws_security_group_rule" "autoscaling-sg-all-out"{
        from_port                   = 0
        protocol                    = "all"
        security_group_id           = aws_security_group.my-autoscaling-sg.id
        to_port                     = 65535
        type                        = "egress"
        cidr_blocks                 = ["0.0.0.0/0"]
    }