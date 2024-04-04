data "aws_ami" "aws_optimized_ecs" {
  most_recent = true
  filter {
    name   = "name"
    values = ["*ecs*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["591542846629"] # AWS
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.clusterName

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_launch_configuration" "ecs_launch_template" {
  name_prefix          = "${var.clusterName}_EcsInstance"
  image_id             = data.aws_ami.aws_optimized_ecs.id
  security_groups      = var.sg_ids
  iam_instance_profile = var.ecs_instance_profile_arn
  associate_public_ip_address = false

  user_data = <<EOF
    #!/bin/bash
    echo ECS_CLUSTER=${var.clusterName} >> /etc/ecs/ecs.config
    echo ECS_AWSVPC_BLOCK_IMDS=true >> /etc/ecs/ecs.config
    echo ECS_AWSVPC_BLOCK_METADATA=true >> /etc/ecs/ecs.config
    echo ECS_CLUSTER=${var.clusterName} >> /etc/ecs/ecs.config
    DD_API_KEY=9f484aa9df31b8a4fc2932233027a143 DD_SITE="datadoghq.eu" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"
    EOF

  instance_type        = "m5.xlarge"
  key_name             = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

output "ecs_cluster_name" {
  description = "Name of the created ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.name
}

#ASG

resource "aws_autoscaling_group" "ecs_asg" {
  name_prefix                = "${var.clusterName}_ags"
  vpc_zone_identifier       = var.subnet_ids
  min_size               = var.min_size
  max_size               = 2
  desired_capacity       = 1
  health_check_grace_period = 150
  health_check_type         = "EC2"
  launch_configuration      = aws_launch_configuration.ecs_launch_template.name

  lifecycle {
    create_before_destroy = false
  }

  tag {
    key = "ECS_managed"
    value = var.clusterName
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_schedule" "autoscaling_schedule_ecs_upscale" {
  scheduled_action_name  = "upscale-schedule-ecs"
  min_size               = var.min_size_up
  max_size               = 2
  desired_capacity       = 1
  recurrence             = var.upscaling_recurrence
  time_zone              = "Europe/Bratislava"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name
}

resource "aws_autoscaling_schedule" "autoscaling_schedule_ecs_downscale" {
  scheduled_action_name  = "downscale-schedule-ecs"
  min_size               = var.min_size_down
  max_size               = 2
  desired_capacity       = var.desired_size_down
  recurrence             = var.downscaling_recurrence
  time_zone              = "Europe/Bratislava"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name
}