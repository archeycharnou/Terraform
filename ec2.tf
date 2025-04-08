
#####################################
# Data Source to fetch the most recent AWS Linux 2 Image from AWS & Use for Launch Template
#####################################

data "aws_ami" "mostrecent" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}


#####################################
# EC2 Auto Scaling Group Launch Template
#####################################

resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-launch-template"
  image_id      = data.aws_ami.mostrecent.image_id
  instance_type = "t2.micro"


  network_interfaces {
    security_groups             = [aws_security_group.ec2_sg.id]
    associate_public_ip_address = true
  }

  # 169.254.169.254 is AWS’s internal Instance Metadata Service. It allows an EC2 instance to retrieve information about itself without needing an internet connection.
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y nginx
    instance_ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
    echo "$instance_ip" > /usr/share/nginx/html/index.html
    systemctl enable nginx
    systemctl start nginx
    EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web-server-instance"
    }
  }
}


#####################################
# EC2 Auto Scaling Group
#####################################

resource "aws_autoscaling_group" "web_asg" {
  name                      = "web-asg"
  max_size                  = 4
  min_size                  = 1
  desired_capacity          = 2
  vpc_zone_identifier       = aws_subnet.public[*].id
  target_group_arns         = [aws_lb_target_group.tg.arn]
  health_check_type         = "EC2"
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-server-asg"
    propagate_at_launch = true
  }
}

#####################################
# EC2 Auto Scaling Group Scale policies to work with Cloudwatch
#####################################

# Scale OUT
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

# Scale IN
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}
