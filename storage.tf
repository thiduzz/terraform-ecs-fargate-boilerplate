resource "aws_s3_bucket" "s3-lb-logs-env-test" {
  bucket = "s3-lb-logs-env-test-bucket"
  acl    = "private"
  force_destroy = true
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
  tags = {
    Name        = "Access Logs bucket"
    Environment = "Dev"
  }
}