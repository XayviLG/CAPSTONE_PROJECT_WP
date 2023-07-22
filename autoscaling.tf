#Creating an AMI for AutoScaling

resource "aws_ami_from_instance" "autoami" {
  name               = "auto_scaling_ami"
  source_instance_id = aws_instance.wordpress.id
}

#Launch Template

resource "aws_launch_template" "my_launch_template" {

  name = "my_launch_template"
  
  image_id = "ami-0507f77897697c4ba"
  instance_type = "t2.micro"
  key_name = "cool"
  user_data = filebase64("${path.module}/userdata.sh")

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.devVPC_sg_allow_http.id]
  }
}

#Autoscaling Group

resource "aws_autoscaling_group" "my_asg" {
  name                      = "my_asg"
  max_size                  = 4
  min_size                  = 2
  health_check_type         = "ELB"    # optional
  health_check_grace_period = 300
  desired_capacity          = 2
  target_group_arns = [aws_lb_target_group.my_tg.arn]

  vpc_zone_identifier       = [aws_subnet.private_subneta.id, aws_subnet.private_subnetb.id]
  
  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }
}

#Scale-up policy

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"      # add one instance
  cooldown               = "120"    # cooldown period after scaling
}

#Scale-up cloud-watch alarm

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "scale-up-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "50"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.my_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}

#Scale-down policy

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

#Scale-down cloud-watch alarm

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.my_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
}