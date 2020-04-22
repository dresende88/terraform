// Web server security group

resource "aws_security_group" "sg_web_server" {
  name_prefix = "sg-ws-"
  description = "Security Group for web server"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = var.name
    Environment = var.environment
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    description     = "HTTP"
    security_groups = [aws_security_group.sg_lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "Allowing outbound traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Memcached security group

resource "aws_security_group" "sg_memcached_lab" {
  name_prefix = "sg-memcached-lab-"
  description = "Security Group for Memcached lab"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = var.name
    Environment = var.environment
  }

  ingress {
    description = "Allow VPC traffic"
    from_port   = local.memcached_port
    to_port     = local.memcached_port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


// Load balancer security group

resource "aws_security_group" "sg_lb" {
  name_prefix = "sg-lb-"
  description = "Security Group for Load balancer"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = var.name
    Environment = var.environment
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "Allowing outbound traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


// Security group

resource "aws_security_group" "redis_lab" {
  name        = "security-group-redis-lab"
  description = "Security Group for Redis lab"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = var.name
    Environment = var.environment
  }

  ingress {
    description = "Allow VPC traffic"
    from_port   = local.redis_port
    to_port     = local.redis_port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}