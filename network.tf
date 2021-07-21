resource "aws_vpc" "main" {
  cidr_block       = "172.32.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "main"
    Environment = "Dev"
  }
}

resource "aws_internet_gateway" "gw-env-test" {
  vpc_id = aws_vpc.main.id
  tags = {
    Environment = "Dev"
  }
}

resource "aws_route_table" "rt-env-test" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-env-test.id
  }

  tags = {
    Name = "Env Test Route Table"
    Environment = "Dev"
  }
}

resource "aws_subnet" "subnet_az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.32.0.0/20"
  availability_zone = "eu-central-1a"
  tags = {
    Name = "Default subnet for eu-central-1a"
    Environment = "Dev"
  }
}

resource "aws_subnet" "subnet_az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.32.16.0/20"
  availability_zone = "eu-central-1b"
  tags = {
    Name = "Default subnet for eu-central-1b"
    Environment = "Dev"
  }
}

resource "aws_subnet" "subnet_az3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.32.32.0/20"
  availability_zone = "eu-central-1c"
  tags = {
    Name = "Default subnet for eu-central-1c"
    Environment = "Dev"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Environment = "Dev"
    Tier = "Public"
  }
}

resource "aws_security_group" "sg-env-test" {
  name        = "sg-env-test"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }


  ingress {
    description      = "Non-TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  tags = {
    Environment = "Dev"
  }
}


resource "aws_lb" "lb-env-test" {
  name               = "lb-env-test"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-env-test.id]
  subnets            = [
    aws_subnet.subnet_az1.id,
    aws_subnet.subnet_az2.id,
    aws_subnet.subnet_az3.id
  ]
  ip_address_type = "ipv4"

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.s3-lb-logs-env-test.bucket
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "Dev"
  }
}

resource "aws_lb_target_group" "lb-tg-blue-env-test" {
  name     = "lb-tg-blue-env-test"
  port     = 80
  protocol = "HTTP"
  target_type = "IP"
  vpc_id   = aws_vpc.main.id

  health_check {
    port     = 80
    protocol = "HTTP"
  }
}

resource "aws_lb_target_group" "lb-tg-green-env-test" {
  name     = "lb-tg-green-env-test"
  port     = 80
  protocol = "HTTP"
  target_type = "IP"
  vpc_id   = aws_vpc.main.id

  health_check {
    port     = 80
    protocol = "HTTP"
  }
}

resource "aws_lb_listener" "lb-listener-1-env-test" {
  load_balancer_arn = aws_lb.lb-env-test.id
  port = 80

  default_action {
    target_group_arn = aws_lb_target_group.lb-tg-green-env-test.id
    type             = "forward"
  }
}

resource "aws_lb_listener" "lb-listener-2-env-test" {
  load_balancer_arn = aws_lb.lb-env-test.id
  port = 8080

  default_action {
    target_group_arn = aws_lb_target_group.lb-tg-green-env-test.id
    type             = "forward"
  }
}