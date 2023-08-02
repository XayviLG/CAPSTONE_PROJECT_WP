# Security Group for Bastion
resource "aws_security_group" "my_sg_bastion"{
    vpc_id = aws_vpc.myVPC.id
    name = "my_securityGrouplatest"
    tags = {
        Name = "cap-sg-bastion"
    }
    provisioner "local-exec"{
    command = "echo Security Group Bastion = ${self.id} >> metadata"
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
         provisioner "local-exec"{
        command = "echo Security Group ALB = ${self.id} >> metadata"
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
        provisioner "local-exec"{
        command = "echo Security Group Autoscaling = ${self.id} >> metadata"
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

# MYSQL Security Group

    resource "aws_security_group" "cpstn-sqldb-sg"{
        vpc_id                      = aws_vpc.myVPC.id
        name                        = "cpstn-sqldb-sg"
        tags = {
            Name = "cpstn-sqldb-sg"
        }
        provisioner "local-exec"{
        command = "echo Security Group MYSQL = ${self.id} >> metadata"
        }  
    }
    resource "aws_security_group_rule" "mysql-sg-bastion-in"{
        from_port                   = 3306
        protocol                    = "tcp"
        security_group_id           = aws_security_group.cpstn-sqldb-sg.id
        to_port                     = 3306
        type                        = "ingress"
        source_security_group_id    = aws_security_group.my_sg_bastion.id
    }
    resource "aws_security_group_rule" "mysql-sg-autoscaling-in"{
        from_port                   = 3306
        protocol                    = "tcp"
        security_group_id           = aws_security_group.cpstn-sqldb-sg.id
        to_port                     = 3306
        type                        = "ingress"
        source_security_group_id    = aws_security_group.my-autoscaling-sg.id
    }
 /**resource "aws_security_group_rule" "mysql-sg-autoscaling-out"{
        from_port                   = 3306
        protocol                    = "tcp"
        security_group_id           = aws_security_group.cpstn-sqldb-sg.id
        to_port                     = 3306
        type                        = "egress"
        source_security_group_id    = aws_security_group.my-autoscaling-sg.id
    }**/  