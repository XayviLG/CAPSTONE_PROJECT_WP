resource "aws_network_acl" "my_nacl" {
  vpc_id = aws_vpc.myVPC.id

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
    Name = "my_nacl"
  }
}
resource "aws_network_acl_association" "my_nacl" {
  network_acl_id = aws_network_acl.my_nacl.id
  subnet_id      = aws_subnet.my_publicSubnet_2.id
}