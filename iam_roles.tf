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
