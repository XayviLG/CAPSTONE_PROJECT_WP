# Security Group for Bastion
resource "aws_security_group" "cpstn_sg_bastion"{
        vpc_id                      = aws_vpc.cpstn_vpc.id
        name                        = "cpstn_securityGrouplatest"
        tags                        = {
        Name                        = "cap-sg-bastion"
    }
    provisioner "local-exec"{
        command                     = "echo Security Group Bastion = ${self.id} >> metadata"
    }          
}

# Rules bastion - Ingress Security Port 22 (Inbound)
        resource "aws_security_group_rule" "cpstn_ingress_ssh"{
        from_port                   = 22
        protocol                    = "tcp"
        security_group_id           = aws_security_group.cpstn_sg_bastion.id
        to_port                     = 22
        type                        = "ingress"
        cidr_blocks                 = [var.cidr_blocks] # <Specify the CIDR> instead of allowing it to public
}

# Rules bastion - Allow Access All (Outbound)
        resource "aws_security_group_rule" "cpstn_outbound_all"{
        from_port                   = 22
        protocol                    = "tcp"
        security_group_id           = aws_security_group.cpstn_sg_bastion.id
        to_port                     = 22
        type                        = "egress"
        cidr_blocks                 = [var.cidr_blocks]
}
# Security Group for Application Load balancer and rules
resource "aws_security_group" "cpstn_alb_sg"{
        vpc_id                      = aws_vpc.cpstn_vpc.id
        name                        = "alb-sg"
        tags                        = {
        Name                        = "cap-alb-sg"
        }
        provisioner "local-exec"{
        command                     = "echo Security Group ALB = ${self.id} >> metadata"
        } 
}
        resource "aws_security_group_rule" "alb-sg-http-in"{
        from_port                   = 80
        protocol                    = "tcp"
        security_group_id           = aws_security_group.cpstn_alb_sg.id
        to_port                     = 80
        type                        = "ingress"
        cidr_blocks                 = [var.cidr_blocks]
}
        resource "aws_security_group_rule" "alb-sg-https-in"{
        from_port                   = 443
        protocol                    = "tcp"
        security_group_id           = aws_security_group.cpstn_alb_sg.id
        to_port                     = 443
        type                        = "ingress"
        cidr_blocks                 = [var.cidr_blocks]
}
        resource "aws_security_group_rule" "alb-sg-all-out"{
        from_port                   = 0
        protocol                    = "all"
        security_group_id           = aws_security_group.cpstn_alb_sg.id
        to_port                     = 65535
        type                        = "egress"
        cidr_blocks                 = [var.cidr_blocks]
}
#Security Group for Autoscaling and rules
resource "aws_security_group" "cpstn_autoscaling_sg"{
        vpc_id                      = aws_vpc.cpstn_vpc.id
        name                        = "autoscaling-sg"
        tags                        = {
        Name                        = "cap-autoscaling-sg"
        }
        provisioner "local-exec"{
        command                     = "echo Security Group Autoscaling = ${self.id} >> metadata"
        } 
}
        resource "aws_security_group_rule" "autoscaling-sg-ssh-in"{
        from_port                   = 22
        protocol                    = "tcp"
        security_group_id           = aws_security_group.cpstn_autoscaling_sg.id
        to_port                     = 22
        type                        = "ingress"
        cidr_blocks                 = [var.cidr_blocks]
}
        resource "aws_security_group_rule" "autoscaling-sg-http-in"{
        from_port                   = 80
        protocol                    = "tcp"
        security_group_id           = aws_security_group.cpstn_autoscaling_sg.id
        to_port                     = 80
        type                        = "ingress"
        cidr_blocks                 = [var.cidr_blocks]
}
        resource "aws_security_group_rule" "autoscaling-sg-all-out"{
        from_port                   = 0
        protocol                    = "all"
        security_group_id           = aws_security_group.cpstn_autoscaling_sg.id
        to_port                     = 65535
        type                        = "egress"
        cidr_blocks                 = [var.cidr_blocks]
}

# MYSQL Security Group

resource "aws_security_group" "cpstn-sqldb-sg"{
        vpc_id                      = aws_vpc.cpstn_vpc.id
        name                        = "cpstn-sqldb-sg"
        tags                        = {
        Name                        = "cpstn-sqldb-sg"
        }
        provisioner "local-exec"{
        command                     = "echo Security Group MYSQL = ${self.id} >> metadata"
        }  
}
        resource "aws_security_group_rule" "cpstn_sql_sg_bastion_in"{
        from_port                   = 3306
        protocol                    = "tcp"
        security_group_id           = aws_security_group.cpstn-sqldb-sg.id
        to_port                     = 3306
        type                        = "ingress"
        source_security_group_id    = aws_security_group.cpstn_sg_bastion.id
}
        resource "aws_security_group_rule" "cpstn_sql_sg_autoscaling_in"{
        from_port                   = 3306
        protocol                    = "tcp"
        security_group_id           = aws_security_group.cpstn-sqldb-sg.id
        to_port                     = 3306
        type                        = "ingress"
        source_security_group_id    = aws_security_group.cpstn_autoscaling_sg.id
}
/**     resource "aws_security_group_rule" "cpstn_sql_sg_autoscaling_out"{
        from_port                   = 3306
        protocol                    = "tcp"
        security_group_id           = aws_security_group.cpstn-sqldb-sg.id
        to_port                     = 3306
        type                        = "egress"
        source_security_group_id    = aws_security_group.cpstn_autoscaling_sg.id
}**/  