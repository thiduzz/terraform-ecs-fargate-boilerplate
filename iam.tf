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

resource "aws_iam_role" "s3-logs-role-env-test" {
  name = "s3-logs-role-env-test"
  assume_role_policy = data.aws_iam_policy_document.s3-policy-document-env-test.json
  managed_policy_arns = [
    aws_iam_policy.s3-lb-access-logs-policy.arn
  ]
}



data "aws_iam_policy_document" "s3-policy-document-env-test" {
  statement {
    sid = "S3AssumeRole"
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["s3.amazonaws.com"]
      type = "Service"
    }
  }
}

data "aws_iam_policy_document" "lb-policy-document-env-test" {
  statement {
    sid = "LbAssumeRole"
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["arn:aws:iam::054676820928:root"]
      type = "AWS"
    }
  }
}

data "aws_iam_policy_document" "delivery-policy-document-env-test" {
  statement {
    sid = "DeliveryLogsAssumeRole"
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_policy" "s3-lb-access-logs-policy" {
  name        = "s3-lb-access-logs-policy"
  description = "A policy that allows LB to put logs in a S3 bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::054676820928:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::s3-lb-logs-env-test-bucket/test-lb/AWSLogs/411705946934/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::s3-lb-logs-env-test-bucket/test-lb/AWSLogs/411705946934/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::s3-lb-logs-env-test-bucket"
    }
  ]
}
EOF
}