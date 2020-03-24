resource "aws_instance" "test" {
  ami           = local.ami_id
  key_name      = local.keyname
  instance_type = local.size
  security_groups             = [aws_security_group.test-sg.id]
  subnet_id                   = data.aws_subnet.test.0.id
  associate_public_ip_address = false

  root_block_device {
    volume_type           = local.vol_type_so
    volume_size           = local.vol_size_so
    delete_on_termination = true
  }

  tags = {
    Name    = local.name
    company = local.company
    env     = local.env
    group   = local.group
    role    = local.role
    system  = local.system
    type    = local.type
  }
}

resource "aws_security_group" "test-sg" {
  name        = "test-security-group"
  description = "Security Group for bastion server DB"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
  }

