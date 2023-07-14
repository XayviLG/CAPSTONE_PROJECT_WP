resource "aws_security_group" "devVPC_sg_allow_ssh_http"{
    vpc_id = aws_vpc.devVPC.id
    name = "devVPC_terraform_vpc_allow_ssh_http"
    tags = {
        Name = "devVPC_terraform_sg_allow_ssh_http"
    }
}
# Ingress Security Port 22 (Inbound) - Provides a security group rule resource (https://registry.terraform.io.providers/hashicorp/aws/latest/docs/resources/security_group_rule)
resource "aws_security_group_rule" "devVPC_ssh_ingress_access"{
    from_port = 22
    protocol = "tcp"
    security_group_id = aws_security_group.devVPC_sg_allow_ssh_http.id
    to_port = 22
    type = "ingress"
    cidr_blocks = [var.cidr_blocks]
}
# Ingress Security Port 80 (Inbound)
resource "aws_security_group_rule" "devVPC_http_ingress_access"{
    from_port = 80
    protocol = "tcp"
    security_group_id = aws_security_group.devVPC_sg_allow_ssh_http.id
    to_port= 80
    type = "ingress"
    cidr_blocks = [var.cidr_blocks]
}
# Ingress Security Port 8080 (Inbound)
resource "aws_security_group_rule" "devVPC_http8080_ingress_access"{
    from_port = 8080
    protocol = "tcp"
    security_group_id = aws_security_group.devVPC_sg_allow_ssh_http.id
    to_port= 8080
    type = "ingress"
    cidr_blocks = [var.cidr_blocks]
}
# Egress Security (Outbound) - Allow all outbound traffic
resource "aws_security_group_rule" "devVPC_egress_access" {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_blocks]
    security_group_id = aws_security_group.devVPC_sg_allow_ssh_http.id
    type = "egress"
}