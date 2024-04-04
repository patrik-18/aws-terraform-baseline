module "development_ecs" {
  source = "../../modules/ecs"

  clusterName = "development-ecs-cluster"
  key_name    = "development_meliovit_keypair"
  subnet_ids  = [ 
                  module.subnets.private_ecs_subnet_1a_id,
                  module.subnets.private_ecs_subnet_1b_id,
                ]
  ecs_instance_profile_arn = aws_iam_instance_profile.ecs_instance_profile.arn
  sg_ids = [ aws_security_group.ecs_ec2_sg.id ]

  upscaling_recurrence = "0 7 * * 1-7"
  downscaling_recurrence = "0 23 * * 1-7"
}