resource "aws_s3_bucket" "s3-lb-logs-env-test" {
  bucket = "s3-lb-logs-env-test-bucket"
  acl    = "private"

  tags = {
    Name        = "Access Logs bucket"
    Environment = "Dev"
  }
}