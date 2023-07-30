#Load Balancer

resource "aws_lb" "my_loadBalancer" {
  name                              = "myWebserver-alb"
  internal                          = false
  load_balancer_type                = "application"
  security_groups                   = [aws_security_group.my-alb-sg.id]
  subnets                           = [aws_subnet.my_publicSubnet_1.id, aws_subnet.my_publicSubnet_2.id]
  enable_deletion_protection        = false
    tags = {
        Environment                 = "production"
  }
}

#Target Group

resource "aws_lb_target_group" "my-target-group" {
  name                              = "CPUtest-tg"
  port                              = 80
  protocol                          = "HTTP"
  vpc_id                            = aws_vpc.myVPC.id
}

#Listener

resource "aws_lb_listener" "my-listener" {
  load_balancer_arn                 = aws_lb.my_loadBalancer.arn
  port                              = 80
  protocol                          = "HTTP"
  default_action {
    type                            = "forward"
    target_group_arn                = aws_lb_target_group.my-target-group.arn
  }
}
