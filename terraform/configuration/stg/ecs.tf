module "staging_ecs" {
  source = "../../modules/ecs"

  clusterName = "staging-ecs-cluster-stg"
  key_name    = "staging_meliovit_keypair"
  subnet_ids  = [ 
                  module.subnets.private_ecs_subnet_1a_id,
                  module.subnets.private_ecs_subnet_1b_id,
                ]
  ecs_instance_profile_arn = aws_iam_instance_profile.ecs_instance_profile.arn
  sg_ids = [ aws_security_group.ecs_ec2_sg.id ]

  upscaling_recurrence = "0 7 * * 1-5"
  downscaling_recurrence = "0 23 * * 1-5"
}