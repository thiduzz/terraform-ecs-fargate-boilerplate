resource "aws_iam_role" "ecs-task-exec-role-env-test" {
  name = "ecs-task-exec-role-env-test"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name        = "ECS Task Execution Role"
    Environment = "Dev"
  }
}

//resource "aws_iam_service_linked_role" "ecs-role-svc-env-test" {
//  aws_service_name = "ecs.amazonaws.com"
//  description = "Linked Role created via Terraform for Env Test"
//}

//ECR Definitions

variable "environment" {
  type    = string
  default = "staging"
}

# user to pull docker images to ecr
resource "aws_iam_user" "docker-ecr-ro" {
    name = "docker-ecr-ro"
    path = "/services/"

    tags = {
        Name        = "docker-ecr-ro"
        Environment = var.environment
        Project     = "global"
    }
}

resource "aws_iam_user" "docker-ecr-full" {
    name = "docker-ecr-full"
    path = "/services/"

    tags = {
        Name        = "docker-ecr-full"
        Environment = var.environment
        Project     = "global"
    }
}

resource "aws_iam_access_key" "docker-ecr-ro" {
    user = aws_iam_user.docker-ecr-ro.name
}

resource "aws_iam_access_key" "docker-ecr-full" {
    user = aws_iam_user.docker-ecr-full.name
}

resource "aws_iam_user_policy_attachment" "docker-ecr-ro" {
    user       = aws_iam_user.docker-ecr-ro.name
    policy_arn = aws_iam_policy.docker-ecr-ro.arn
}

resource "aws_iam_user_policy_attachment" "docker-ecr-full" {
    user       = aws_iam_user.docker-ecr-full.name
    policy_arn = aws_iam_policy.docker-ecr-full.arn
}

output "ecr-secret-1" {
  value = aws_iam_access_key.docker-ecr-ro.secret
  description = "Secret ECR Pull-only:"
  sensitive = true
}

output "ecr-secret-2" {
  value = aws_iam_access_key.docker-ecr-full.secret
  description = "Secret ECR Full:"
  sensitive = true
}