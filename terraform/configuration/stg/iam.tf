# ECS INSTANCE IAM POLICIES
data "aws_iam_policy_document" "ecs_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_instance_role" {
  name               = "ecs-instance-role-stg"
  assume_role_policy = data.aws_iam_policy_document.ecs_policy_document.json
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachemnt" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs-instance-profile-stg"
  role = aws_iam_role.ecs_instance_role.name
}

# TASK IAM POLICIES

data "aws_iam_policy_document" "iam_task_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
 
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# IAM role for ecs task execution
resource "aws_iam_role" "task_execution_role" {
  name                = "task-execution-role-stg"
  assume_role_policy  =  data.aws_iam_policy_document.iam_task_policy_document.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
  inline_policy {
    name = "KmsEcsPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
        Action   = ["kms:Decrypt","kms:Encrypt","kms:GenerateDataKey"]
        Effect   = "Allow"
        Resource = ["arn:aws:kms:*:425849881595:key/*"]        
        },
      ]
    })
  }
  inline_policy {
    name = "s3"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["secretsmanager:GetSecretValue"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
  inline_policy {
    name = "SesPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
        Action   = ["ses:*"]
        Effect   = "Allow"
        Resource = "*"
        },
      ]
    })
  }
}
 
# IAM role for ecs task
resource "aws_iam_role" "task_role" {
  name                = "task-role-stg"
  assume_role_policy  = data.aws_iam_policy_document.iam_task_policy_document.json
  managed_policy_arns = [
                          "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole",
                          "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
                          ]
  inline_policy {
    name = "s3"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["s3:GetObject*",
                      "s3:List*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  } 
  inline_policy {
    name = "KmsEcsPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
        Action   = ["kms:Decrypt","kms:Encrypt","kms:GenerateDataKey"]
        Effect   = "Allow"
        Resource = ["arn:aws:kms:*:425849881595:key/*"]        
        },
      ]
    })
  }
  inline_policy {
    name = "SsmPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
        Action   = ["ssm:GetParameters","secretsmanager:GetSecretValue","ecr:GetAuthorizationToken"]
        Effect   = "Allow"
        Resource = "*"
        },
      ]
    })
  }
  inline_policy {
    name = "CognitoPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
        Action   = ["cognito-idp:adminAddUserToGroup","cognito-idp:AdminCreateUser","cognito-idp:AdminGetUser","cognito-idp:ForgotPassword","cognito-idp:GlobalSignOut","cognito-idp:ConfirmSignUp","cognito-idp:CreateUserPool","cognito-idp:ForgetDevice","cognito-idp:RevokeToken","cognito-idp:GetUserAttributeVerificationCode","cognito-idp:InitiateAuth","cognito-idp:DeleteUser","cognito-idp:SetUserMFAPreference","cognito-idp:GetUser","cognito-idp:ConfirmForgotPassword","cognito-idp:SetUserSettings","cognito-idp:SignUp","cognito-idp:VerifyUserAttribute","cognito-idp:ListDevices","cognito-idp:ListUserPools","cognito-idp:AssociateSoftwareToken","cognito-idp:VerifySoftwareToken","cognito-idp:GetDevice","cognito-idp:RespondToAuthChallenge","cognito-idp:DeleteUserAttributes","cognito-idp:UpdateUserAttributes","cognito-idp:DescribeUserPoolDomain","cognito-idp:UpdateDeviceStatus","cognito-idp:ChangePassword","cognito-idp:ConfirmDevice","cognito-idp:ResendConfirmationCode"]
        Effect   = "Allow"
        Resource = "*"
        },
      ]
    })
  }
}

# IAM Role and Policy for SMS

resource "aws_iam_role" "cognito_sms_role" {
  name = "cognito-sms-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cognito-idp.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "cognito_sms_policy" {
  name        = "cognito-sms-policy"
  description = "IAM policy for sending SMS messages from Cognito"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "VisualEditor0",
        Effect = "Allow",
        Action = [
          "sns:Publish"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cognito_sms_role_policy_attachment" {
  policy_arn = aws_iam_policy.cognito_sms_policy.arn
  role       = aws_iam_role.cognito_sms_role.name
}
