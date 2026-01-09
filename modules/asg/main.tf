# Launch Template #

resource "aws_launch_template" "this" {
  name          = "${var.name}-${var.environment}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.sg_id]

  user_data = var.user_data



  # Opcjonalny IAM instance profile
  dynamic "iam_instance_profile" {
    for_each = var.instance_profile_arn == null ? [] : [1]

    content {
      arn = var.instance_profile_arn
    }
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.root_volume_size
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      {
        Name        = var.name
        Project     = var.project
        Environment = var.environment
      },
      var.tags,
    )
  }
}


# ASG #
resource "aws_autoscaling_group" "this" {
  name                = "${var.name}-asg"
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.subnet_ids

  target_group_arns = var.target_group_arns

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

# Target Tracking Scaling Policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.name}-scale-up"
  metric_aggregation_type = "Average"
  policy_type = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.this.name
  
  target_tracking_configuration {
    target_value = 30 

    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"  
    }
  }

  depends_on = [aws_autoscaling_group.this]
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.name}-scale-down"
  metric_aggregation_type = "Average"
  policy_type = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.this.name
 
  target_tracking_configuration {
    target_value = 30  

    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"  
    }
  }

  depends_on = [aws_autoscaling_group.this]
}
