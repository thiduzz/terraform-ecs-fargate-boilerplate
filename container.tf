resource "aws_ecs_cluster" "ecs-cl-env-test" {
  name = "ecs-cl-env-test"
  configuration {
    execute_command_configuration {
      logging    = "OVERRIDE"
      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs-cl-logs-env-test.name
      }
    }
  }
  tags = {
    Name        = "ECS Cluster Env Test"
    Environment = "Dev"
  }
}

resource "aws_ecs_service" "ecs-svc-env-test" {
  name            = "ecs-svc-env-test"
  cluster         = aws_ecs_cluster.ecs-cl-env-test.id
  task_definition = aws_ecs_task_definition.ecs-task-env-test.arn
  desired_count   = 1
  //iam_role        = aws_iam_service_linked_role.ecs-role-svc-env-test.arn
  //iam_role = "arn:aws:iam::411705946934:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  launch_type = "FARGATE"
  scheduling_strategy = "REPLICA"

  # Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [desired_count]
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [
      aws_security_group.security-group-env-test.id
    ]
    subnets = [
      aws_subnet.subnet_az1.id,
      aws_subnet.subnet_az2.id,
      aws_subnet.subnet_az3.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb-tg-green-env-test.arn
    container_name   = "app-container-test-env"
    container_port   = 8080
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-central-1a, eu-central-1b, eu-central-1c]"
  }

  tags = {
    Name        = "ECS Service Env Test"
    Environment = "Dev"
  }
}

resource "aws_ecs_task_definition" "ecs-task-env-test" {
  family = "ecs-task-env-test"

  container_definitions = jsonencode([
    {
      name      = "app-container-test-env"
      image     = "nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
    }
  ])

  requires_compatibilities = [
    "FARGATE"
  ]

  network_mode = "awsvpc"
  cpu = "256"
  memory = "512"
  execution_role_arn = aws_iam_role.ecs-task-exec-role-env-test.arn

  tags = {
    Name        = "ECS Task Def. Env Test"
    Environment = "Dev"
  }
}