module "production_ecs" {
  source = "../../modules/ecs"

  clusterName = "production-ecs-cluster"
  key_name    = "production_meliovit_keypair"
  subnet_ids  = [ 
                  module.subnets.private_ecs_subnet_1a_id,
                  module.subnets.private_ecs_subnet_1b_id,
                ]
  ecs_instance_profile_arn = aws_iam_instance_profile.ecs_instance_profile.arn
  sg_ids = [ aws_security_group.ecs_ec2_sg.id ]

  upscaling_recurrence = "0 * * * *"
  downscaling_recurrence = "0 * * * *"

  min_size = 1
  desired_size_down = 1

  min_size_down = 1
  min_size_up = 1
}