/**resource "aws_network_acl" "cpstn_nacl" {
  vpc_id = aws_vpc.cpstn_vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "cpstn_nacl"
  }
}
resource "aws_network_acl_association" "cpstn_nacl" {
  network_acl_id = aws_network_acl.cpstn_nacl.id
  subnet_id      = aws_subnet.cpstn_publicsubnet_1.id
}
resource "aws_network_acl_association" "cpstn_nacl" {
  network_acl_id = aws_network_acl.cpstn_nacl.id
  subnet_id      = aws_subnet.cpstn_publicsubnet_2.id
}**/