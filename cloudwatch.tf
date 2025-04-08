#####################################
# CLOUDWATCH CPU ALARMS
#####################################

# CloudWatch Alarm for Monitoring ASG & Scaling Out (when CPU > 70%)
resource "aws_cloudwatch_metric_alarm" "scale_out" {
  alarm_name          = "high-cpu-scale-out"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "This alarm triggers when CPU usage is above 70%."
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
  # optional if you want auto scaling
  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}

# CloudWatch Alarm for Monitoring ASG & Scaling In (when CPU < 30%)
resource "aws_cloudwatch_metric_alarm" "scale_in" {
  alarm_name          = "low-cpu-scale-in"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "This alarm triggers when CPU usage is below 30%."
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
  # optional if you want auto scaling
  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}
